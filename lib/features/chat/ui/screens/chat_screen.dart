import 'dart:io';

import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../data/models/chat_message_model.dart';
import '../../logic/chat_cubit/chat_state.dart';
import '../../logic/chat_cubit/chat_cubit.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _token;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initAndConnect();
  }

  Future<void> _initAndConnect() async {
    final prefs  = getIt<SharedPrefHelper>();
    final token  = await prefs.getSecureData('token');
    final userId = await prefs.getSecureData('id');

    if (!mounted) return;

    setState(() {
      _token         = token;
      _currentUserId = userId;
    });

    if (_token != null) {
      context.read<ChatCubit>().connectToChat(
        token:      _token!,
        receiverId: widget.receiverId,
      );
    } else {
      context.read<ChatCubit>().emitError('Session expired, please login again');
    }
  }

  void _showEditDialog(ChatMessageModel message) {
    final controller = TextEditingController(text: message.content);
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.background,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Message',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                controller: controller,
                hintText: 'Edit your message...',
                maxLines: 3,
                filled: true,
                fillColor: AppColors.lightprimery,
                focusedBorderColor: AppColors.primery,
                borderColor: Colors.transparent,
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primery,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final newContent = controller.text.trim();
                      if (newContent.isNotEmpty && message.id != null) {
                        context.read<ChatCubit>().editMessage(
                          messageId: message.id!,
                          newContent: newContent,
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImage(File file) async {
    final prefs = getIt<SharedPrefHelper>();
    final token = await prefs.getSecureData('token');
    if (token == null) return;

    await context.read<ChatCubit>().uploadImage(
      token: token,
      receiverId: widget.receiverId,
      imageFile: file,
    );
  }

  void _retry() {
    if (_token != null) {
      context.read<ChatCubit>().connectToChat(
        token:      _token!,
        receiverId: widget.receiverId,
      );
    } else {
      _initAndConnect();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkprimery,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primery,
              child: Text(
                widget.receiverName.isNotEmpty
                    ? widget.receiverName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: AppColors.lightprimery,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.receiverName,
              style: AppStyle.medBlack,
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState<List<ChatMessageModel>>>(
              listener: (context, state) {
                state.when(
                  initial: () {},
                  loading: () {},
                  success: (_) => _scrollToBottom(),
                  fail: (msg) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                );
              },

              builder: (context, state) {
                return state.when(
                  initial: () => const Center(
                    child: Text('Starting chat...'),
                  ),

                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),

                  fail: (message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'Connection failed\n$message',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _retry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),

                  success: (messages) {
                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text(
                              'No messages yet\nSay hello! 👋',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.darksecondary),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMine = msg.sender?.id == _currentUserId;
                        final showDate = index == 0 ||
                            !_isSameDay(
                              messages[index - 1].createdAt,
                              msg.createdAt,
                            );

                        return Column(
                          children: [
                            if (showDate) _buildDateSeparator(msg.createdAt),
                            MessageBubble(
                              message: msg,
                              isMine: isMine,
                              onEdit: (m) => _showEditDialog(m),
                              onDelete: (m) {
                                if (m.id != null) context.read<ChatCubit>().deleteMessage(m.id!);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          ChatInputField(
            onSend: (text) {
              context.read<ChatCubit>().sendMessage(
                content: text,
                receiverId: widget.receiverId,
              );
            },
            onImageSelected: (file, {caption}) async {
              final prefs = getIt<SharedPrefHelper>();
              final token = await prefs.getSecureData('token');
              if (token == null) return;

              await context.read<ChatCubit>().uploadImage(
                token: token,
                receiverId: widget.receiverId,
                imageFile: file,
                caption: caption,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime? date) {
    if (date == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _formatDate(date),
              style: AppStyle.body6,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) return 'Today';
    if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}