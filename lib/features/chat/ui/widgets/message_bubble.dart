import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/chat_message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMine;
  final void Function(ChatMessageModel)? onEdit;
  final void Function(ChatMessageModel)? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDeleted = message.isDeleted ?? false;
    final isEdited  = message.isEdited  ?? false;

    return Align(
      alignment: isMine ? Alignment.centerLeft : Alignment.centerRight,
      child: GestureDetector(
        onLongPress: (!isMine || isDeleted) ? null : () => _showOptions(context),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
          decoration: BoxDecoration(
            color: isMine ? AppColors.primery : AppColors.lightprimery,
            borderRadius: BorderRadius.only(
              topLeft:     Radius.circular(16.r),
              topRight:    Radius.circular(16.r),
              bottomLeft:  isMine ? Radius.zero : Radius.circular(16.r),
              bottomRight: isMine ? Radius.circular(16.r) : Radius.zero,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [

              if (!isDeleted && (message.imageUrl?.isNotEmpty ?? false))
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    message.imageUrl!,
                    width: 200.w,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),

              if (!isDeleted && (message.imageUrl?.isNotEmpty ?? false) &&
                  (message.content?.isNotEmpty ?? false))
                const SizedBox(height: 6),

              if (isDeleted)
                Row(
                  children: [
                    Icon(Icons.not_interested , color: isMine ? AppColors.background : AppColors.light, size: 17,),
                    SizedBox(width: 5.w,),
                    Text(
                      'Message deleted',
                      style: TextStyle(
                        color: isMine ? AppColors.background : AppColors.light,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              else if (message.content?.isNotEmpty ?? false)
                Text(
                  message.content!,
                  style: TextStyle(
                    color: isMine ? AppColors.background : AppColors.primery,
                    fontSize: 15,
                  ),
                ),

              const SizedBox(height: 4),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isEdited && !isDeleted)
                    Text(
                      'edited · ',
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color:  isMine ? AppColors.background : AppColors.light,
                      ),
                    ),
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: isMine ? Colors.white70 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Message'),
              onTap: () {
                Navigator.pop(context);
                onEdit?.call(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.ternary),
              title: const Text('Delete Message', style: TextStyle(color: AppColors.ternary)),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}