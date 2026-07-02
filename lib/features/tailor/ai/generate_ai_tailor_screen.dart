import 'dart:io';
import 'dart:typed_data';
import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/features/chat/logic/conversations_cubit/conversations_cubit.dart';
import 'package:chicora/features/chat/ui/widgets/chat_input_field.dart';
import 'package:chicora/features/customer/ai/generate/logic/cubit/ai_generator_cubit.dart';
import 'package:chicora/features/customer/ai/generate/ui/widgets/full_screen_image.dart';

import 'package:chicora/features/customer/ai/generate/logic/cubit/ai_generator_state.dart';
import 'package:chicora/features/customer/ai/generate/ui/widgets/other_dialog_widget.dart';
import 'package:chicora/features/customer/ai/generate/ui/widgets/yes_no_toggle.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_request_model.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_total_quantity.dart';
import 'package:chicora/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';
import 'package:vision_gallery_saver/vision_gallery_saver_method_channel.dart';

class AiGenerateMessage {
  final String text;
  final File? userImage;
  final Uint8List? aiImage;
  final bool isMine;
  final DateTime createdAt;

  AiGenerateMessage({
    this.text = '',
    this.userImage,
    this.aiImage,
    required this.isMine,
    required this.createdAt,
  });
}

class GenerateImageScreenTailor extends StatefulWidget {
  GenerateImageScreenTailor({super.key});

  @override
  State<GenerateImageScreenTailor> createState() => _AiCustomerScreenState();
}

class _AiCustomerScreenState extends State<GenerateImageScreenTailor> {
  String? _currentUserId;
  bool _useMyMeasurements = false;
  final List<AiGenerateMessage> _messages = [];
  Uint8List? _lastGeneratedImage;
  MeasurementsModel? _others;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    context.read<ConversationsCubit>().loadUnreadCount();
  }

  Future<void> _loadUserId() async {
    final prefs = getIt<SharedPrefHelper>();
    final id = await prefs.getSecureData(SharedPrefKey.id);
    if (!mounted) return;
    setState(() => _currentUserId = id);
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = cartTotalItemQuantity(context.watch<CartCubit>().state);
    final chatCount = context.watch<ConversationsCubit>().unreadCount;
    final notifCount = context.read<NotificationCubit>().unreadCount;
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: CustomAppBar(
        leading: true,
        title: 'Back to Magic',
        showCartIcon: true,
        cartItemCount: cartCount,
        onCartTap: () =>
            Navigator.pushNamed(context, RouteNames.customer_cart_screen),
        showNotificationIcon: true,
        unreadNotificationCount: notifCount,
        onNotificationTap: () =>
            Navigator.pushNamed(context, RouteNames.notification_screen),
        showChatIcon: true,
        unreadChatCount: chatCount,
        onChatTap: () => Navigator.pushNamed(
          context,
          RouteNames.conversations_screen,
          arguments: {'currentUserId': _currentUserId ?? ''},
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Enter Measurements',
                    style: AppStyle.medGray.copyWith(fontSize: 15.sp),
                  ),
                  YesNoToggle(
                    initialValue: _useMyMeasurements,
                    isTailor: true,

                    onChanged: (value) async {
                      if (!value) {
                        final result = await showOtherMeasuresBottomSheet(
                          context,
                        );
                        if (result != null) {
                          setState(() {
                            _useMyMeasurements = value;
                            _others = result;
                          });
                        }
                      } else {
                        setState(() {
                          _useMyMeasurements = value;
                          _others =
                              null; // reset when switching back to "my measurements"
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<AiGeneratorCubit, AiGeneratorState>(
                listener: (context, state) {
                  state.whenOrNull(
                    success: (data) {
                      setState(() {
                        _lastGeneratedImage = data;
                        _messages.insert(
                          0,
                          AiGenerateMessage(
                            aiImage: data,
                            isMine: false,
                            createdAt: DateTime.now(),
                          ),
                        );
                      });
                    },
                    fail: (msg) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(msg)));
                    },
                  );
                },
                builder: (context, state) {
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  );
                },
              ),
            ),
            BlocBuilder<AiGeneratorCubit, AiGeneratorState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),

            ChatInputField(
              onImageSelected: (file, {caption}) {
                _sendMessage(caption ?? '', _others, imageFile: file);
              },
              onSend: (text) {
                _sendMessage(text, _others);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text, MeasurementsModel? others, {File? imageFile}) {
    setState(() {
      _messages.insert(
        0,
        AiGenerateMessage(
          text: text,
          userImage: imageFile,
          isMine: true,
          createdAt: DateTime.now(),
        ),
      );
    });
    Object? refImage = imageFile;
    if (refImage == null && _lastGeneratedImage != null) {
      refImage = _lastGeneratedImage;
    }
    context.read<AiGeneratorCubit>().generateImage(
      text,
      _useMyMeasurements,
      others,
      referenceImage: refImage,
    );
  }

  Widget _buildMessageBubble(AiGenerateMessage msg) {
    final isMine = msg.isMine;
    return Align(
      alignment: isMine ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.70,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primery : AppColors.lightprimery,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMine ? Radius.zero : Radius.circular(16.r),
            bottomRight: isMine ? Radius.circular(16.r) : Radius.zero,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (msg.userImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 220.h,
                  child: Image.file(msg.userImage!, fit: BoxFit.cover),
                ),
              ),
            if (msg.aiImage != null)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          FullScreenImageViewer(imageBytes: msg.aiImage!),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 220.h,
                    child: Image.memory(msg.aiImage!, fit: BoxFit.cover),
                  ),
                ),
              ),

            if (!isMine && msg.aiImage != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: ElevatedButton(
                  onPressed: () async {
                    PermissionStatus status = await Permission.storage
                        .request();
                    if (!status.isGranted) {
                      status = await Permission.photos.request();
                    }

                    if (status.isGranted) {
                      final result = await VisionGallerySaver.saveImage(
                        msg.aiImage!,
                        name: 'ai_${DateTime.now().millisecondsSinceEpoch}',
                        quality: 100,
                      );

                      if (result['isSuccess'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Image saved to gallery'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to save image')),
                        );
                      }
                    } else if (status.isPermanentlyDenied) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Permission permanently denied. Please enable in settings.',
                          ),
                          action: SnackBarAction(
                            label: 'Settings',
                            onPressed: () {
                              openAppSettings();
                            },
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Storage permission denied'),
                          action: SnackBarAction(
                            label: 'Settings',
                            onPressed: () {
                              openAppSettings();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Download'),
                ),
              ),
            if (msg.userImage != null || msg.aiImage != null)
              const SizedBox(height: 6),
            if (msg.text.isNotEmpty)
              Text(
                msg.text,
                style: TextStyle(
                  color: isMine ? AppColors.background : AppColors.primery,
                  fontSize: 15,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
