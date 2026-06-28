import 'package:chicora/features/ecommerce_multi/data/models/cart_models/cart_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/style.dart';
import '../../../../core/widgets/quantity_counter_widget.dart';

class ProductCartCard extends StatelessWidget {
  const ProductCartCard({
    super.key,
    required this.item,
    required this.isUpdating,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final Item item;
  final bool isUpdating;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final quantity = item.quantity ?? 1;
    final unitPrice = (item.priceAtAddTime ?? item.product?.price ?? 0).toDouble();
    final subtotal = (item.subtotal ?? (unitPrice * quantity).toInt()).toDouble();
    final imageUrl = item.product?.imageUrl;
    final productName = item.product?.name ?? 'Unknown product';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl == null || imageUrl.isEmpty
                    ? Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image, color: Colors.grey),
                      )
                    : Image.network(
                        imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 72,
                          height: 72,
                          color: Colors.grey.shade100,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                  ),
              ),
              const SizedBox(width: 12),

              // Name + Price + Counter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: AppStyle.medBlack),
                    const SizedBox(height: 4),
                    Text(
                      '\$${unitPrice.toStringAsFixed(2)}',
                      style: AppStyle.medPrimery.copyWith(fontSize: 14.sp),
                    ),
                    const SizedBox(height: 10),
                    isUpdating
                        ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(),
                          )
                        : QuantityCounter(
                            quantity: quantity,
                            onIncrement: onIncrement,
                            onDecrement: onDecrement,
                          ),
                  ],
                ),
              ),

              // Remove button
              GestureDetector(
                onTap: onRemove,
                child: Row(
                  children: [
                    Icon(Icons.close, size: 14, color: Colors.redAccent),
                    SizedBox(width: 2),
                    Text(
                      'Remove',
                      style: AppStyle.medTernary.copyWith(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 20, thickness: 0.8),

          // Subtotal row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Subtotal: ',
                style: AppStyle.medGray.copyWith(fontSize: 14.sp),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: AppStyle.medBlack.copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
