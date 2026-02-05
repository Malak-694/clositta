// fabric_model.dart
class ProductModel {
  final String name;
  final double rating;
  final int soldCount;
  final double pricePerYard;
  final int stock;
  final String status; // 'Active', 'Low Stock', 'Out of Stock'

  ProductModel({
    required this.name,
    required this.rating,
    required this.soldCount,
    required this.pricePerYard,
    required this.stock,
    required this.status,
  });
}