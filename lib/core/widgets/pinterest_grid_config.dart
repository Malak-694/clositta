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
  final String? date;
  final String? status;
  final bool showStatus;
  final bool showDate;
  final String? bidsDate;
  final bool showBidsCount;

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
    this.date,
    this.status,
    this.showStatus = false,
    this.showDate = false,
    this.bidsDate,
    this.showBidsCount = false,
  });

  static void _emptyOnTap() {}
}
