import 'dart:io';
import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final Function(File, {String? caption}) onImageSelected;

  const ChatInputField({
    super.key,
    required this.onSend,
    required this.onImageSelected,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  void _handleSend() {
    final text = _controller.text.trim();

    if (_selectedImage != null) {
      widget.onImageSelected(
        _selectedImage!,
        caption: text.isNotEmpty ? text : null,
      );
      setState(() => _selectedImage = null);
      _controller.clear();
      return;
    }

    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _removeImage() => setState(() => _selectedImage = null);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        if (_selectedImage != null)
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            color: AppColors.lightprimery,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    _selectedImage!,
                    height: 350.h,
                    width: 300.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: _removeImage,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.light,
                        shape: BoxShape.circle,
                      ),
                      child:  Icon(
                        Icons.close,
                        color: Theme.of(context).cardColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.light.withOpacity(0.7),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              // Image picker button
              IconButton(
                icon: Icon(
                  Icons.image_outlined,
                  color: _selectedImage != null
                      ? AppColors.primery
                      : AppColors.light,
                ),
                onPressed: _pickImage,
              ),

              // Text field
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  decoration: InputDecoration(
                    hintText: _selectedImage != null
                        ? 'Add a caption... (optional)'
                        : 'Type a message...',
                    filled: true,
                    fillColor: AppColors.lightprimery,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Send button
              CircleAvatar(
                backgroundColor: AppColors.primery,
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).cardColor,
                    size: 18,
                  ),
                  onPressed: _handleSend,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}