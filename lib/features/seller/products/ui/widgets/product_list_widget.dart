import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/ui/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key, required List<ProductModel> filteredProducts})
    : _filteredProducts = filteredProducts;

  final List<ProductModel> _filteredProducts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550.h,
      child: _filteredProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No fabrics found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try a different search term',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return buildProductCard(context, _filteredProducts[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 6),
            ),
    );
  }
}
