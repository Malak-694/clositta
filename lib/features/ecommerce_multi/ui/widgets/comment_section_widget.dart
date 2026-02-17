import 'package:chicora/features/ecommerce_multi/data/models/comment_model.dart';
import 'package:chicora/features/ecommerce_multi/ui/widgets/comment_card_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/style.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.productComments});

  final List<ProductCommentModel> productComments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Reviews', style: AppStyle.medBlack),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productComments.length,
          itemBuilder: (context, index) {
            final comment = productComments[index];
            return CommentCard(comment: comment);
          },
        ),
      ],
    );
  }
}
