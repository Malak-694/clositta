/// API values for seller order filters and updates (see `endpoint.json`).
const List<String> kSellerOrderStatusValues = [
  'placed',
  'confirmed',
  'shipped',
  'delivered',
  'cancelled',
];

String sellerOrderStatusLabel(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}
