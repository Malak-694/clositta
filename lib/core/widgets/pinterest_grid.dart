import 'package:chicora/core/widgets/pinterest_card.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PinterestGrid extends StatelessWidget {
  final List<ProductModelBuyer> products;
  final Function(ProductModelBuyer product) onTap;
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
          return buildPinterestCard(
            products[index],
            () => onTap(products[index]),
          );
        },
      ),
    );
  }
}
