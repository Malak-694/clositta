import 'package:chicora/features/ecommerce_multi/ui/widgets/comment_card_widget.dart';
import 'package:chicora/features/seller/products/data/models/rating_model_response.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/style.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.productComments, this.userRating, this.currentUserId, this.onDelete});

  final List<RatingModel> productComments;
  final RatingModel? userRating;
  final String? currentUserId;
  final void Function(String ratingId)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Reviews', style: AppStyle.medBlack),
        const SizedBox(height: 16),
        Builder(builder: (context) {
          // build a combined list placing the user's rating at the top if provided
          final combined = <RatingModel>[];
          if (userRating != null) combined.add(userRating!);
          combined.addAll(productComments.where((c) => userRating == null || c.user != userRating!.user));

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: combined.length,
            itemBuilder: (context, index) {
              final comment = combined[index];
              return CommentCard(
                comment: comment,
                isOwn: currentUserId != null && comment.user == currentUserId,
                onDelete: onDelete,
              );
            },
          );
        }),
      ],
    );
  }
}
