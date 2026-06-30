import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/conversation_model.dart';
import '../../logic/conversations_cubit/conversations_cubit.dart';
import '../../logic/conversations_cubit/conversations_state.dart';
import '../widgets/conversation_tile.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatelessWidget {
  final String currentUserId;

  const ConversationsScreen({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConversationsCubit>()..loadConversations(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primery,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Messages',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<ConversationsCubit,
            ConversationsState<List<ConversationModel>>>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),

              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primery,
                ),
              ),

              fail: (msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.light),
                    const SizedBox(height: 12),
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.light),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primery,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          context.read<ConversationsCubit>().loadConversations(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

              success: (conversations) {
                if (conversations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No conversations yet',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primery,
                  onRefresh: () =>
                      context.read<ConversationsCubit>().loadConversations(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: conversations.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      indent: 72,
                    ),
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      return ConversationTile(
                        conversation: conv,
                        currentUserId: currentUserId,
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

