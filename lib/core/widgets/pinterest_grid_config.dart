import 'dart:ui';

class PinterestCardConfig<T> {
  final String? imageUrl;
  final String? name;
  final double? rating;
  final int? price;
  final bool showCart;
  final bool showRating;
  final bool showPrice;
  final bool showEdit;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const PinterestCardConfig({
    this.imageUrl,
    this.name,
    this.rating,
    this.price,
    this.showCart = true,
    this.showRating = true,
    this.showPrice = true,
    this.showEdit = false,
    this.onTap = _emptyOnTap,
    this.onEdit,
  });

  static void _emptyOnTap() {}
}