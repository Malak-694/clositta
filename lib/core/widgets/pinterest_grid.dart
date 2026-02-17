import 'package:chicora/core/widgets/pinterest_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PinterestGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final VoidCallback onTap;
  PinterestGrid({super.key, required this.products, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MasonryGridView.count(
        crossAxisCount: 2, // number of columns
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return buildPinterestCard(products[index], onTap);
        },
      ),
    );
  }
}
