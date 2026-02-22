// core/widgets/pinterest_card_config.dart

import 'dart:ui';

class PinterestCardConfig<T> {
  final String? imageUrl;
  final String? name;
  final double? rating;
  final int? price;
  final bool showCart;
  final bool showRating;
  final bool showPrice;
  final VoidCallback onTap;

  const PinterestCardConfig({
    this.imageUrl,
    this.name,
    this.rating,
    this.price,
    this.showCart = true,
    this.showRating = true,
    this.showPrice = true,
    this.onTap = _emptyOnTap,
  });
  static void _emptyOnTap() {}
}
