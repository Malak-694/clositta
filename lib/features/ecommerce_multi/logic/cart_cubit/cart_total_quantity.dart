import 'package:chicora/features/ecommerce_multi/data/models/cart_models/cart_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/cart_models/delete_cart_response_model.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';

/// Sum of line-item quantities in the cart for [state], for UI badges.
int cartTotalItemQuantity(CartState<dynamic> state) {
  return state.maybeMap(
    success: (s) {
      final data = s.data;
      if (data is CartResponseModel) {
        return _sumLineQuantities(data.items);
      }
      if (data is DeleteCartResponseModel) {
        return _sumLineQuantities(data.cart?.items);
      }
      return 0;
    },
    orElse: () => 0,
  );
}

int _sumLineQuantities(List<Item>? items) {
  if (items == null || items.isEmpty) return 0;
  return items.fold<int>(0, (s, e) => s + (e.quantity ?? 0));
}
