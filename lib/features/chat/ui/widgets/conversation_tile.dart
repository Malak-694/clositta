import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/router/route_names.dart';
import '../../data/models/conversation_model.dart';
import '../../logic/conversations_cubit/conversations_cubit.dart';

class ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final String currentUserId;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final other     = conversation.otherUser;
    final name        = other?.name ?? 'Unknown';
    final unread      = conversation.unreadCount ?? 0;
    final time        = _formatTime(conversation.lastMessageAt);

    String _formatLastMessage({String? content, String? messageType}) {
      switch (messageType) {
        case 'image':
          return 'Photo';
        case 'both':
          return '${content ?? 'Photo'}';
        case 'text':
        default:
          return content?.isNotEmpty == true ? content! : 'No messages yet';
      }
    }

    final lastMsgType = conversation.lastMessageType;
    final lastMsg = _formatLastMessage(
      content: conversation.lastMessageContent,
      messageType: lastMsgType,
    );

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

      // ── Avatar ──────────────────────────────────
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: AppColors.lightprimery,
        backgroundImage: (other?.imageUrl != null && other!.imageUrl!.isNotEmpty)
            ? NetworkImage(other.imageUrl!)
            : null,
        child: (other?.imageUrl == null || other!.imageUrl!.isEmpty)
            ? Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: AppColors.primery,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )
            : null,
      ),

      // ── Name + Last message ──────────────────────
      title: Text(
        name,
        style: TextStyle(
          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w500,
          fontSize: 15,
          color: AppColors.dark,
        ),
      ),
      subtitle: Text(
        lastMsg,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: unread > 0 ? AppColors.dark : AppColors.light,
          fontWeight: unread > 0 ? FontWeight.w500 : FontWeight.normal,
          fontSize: 13,
        ),
      ),

      // ── Time + Unread badge ──────────────────────
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: unread > 0 ? AppColors.primery : AppColors.light,
            ),
          ),
          const SizedBox(height: 4),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: AppColors.primery,
                shape: BoxShape.circle,
              ),
              child: Text(
                unread > 99 ? '99+' : '$unread',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),

      onTap: () {
        if (other?.id == null) return;
        Navigator.pushNamed(
          context,
          RouteNames.chat_screen,
          arguments: {
            'receiverId':   other!.id!,
            'receiverName': name,
          },
        ).then((_) {
          context.read<ConversationsCubit>().loadConversations();
        });
      },
    );
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[date.weekday - 1];
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}