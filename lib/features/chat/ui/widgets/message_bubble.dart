
import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/chat_message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMine;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.70, // max 70% width
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primery : AppColors.lightprimery ,
          borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(16.r),
            topRight:  Radius.circular(16.r),
            bottomLeft: isMine ? Radius.zero :  Radius.circular(16.r) ,
            bottomRight: isMine ?Radius.circular(16.r) : Radius.zero ,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Message text
            Text(
              message.content ?? '',
              style: TextStyle(
                color: isMine ? AppColors.background : AppColors.primery,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            // Timestamp
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: isMine ? Colors.white70 : Colors.black38,
              ),
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