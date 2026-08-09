import 'package:bloc/bloc.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_key.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/models/message_model.dart';
import '../../data/models/cart_models/cart_request_model.dart';
import '../../data/models/cart_models/cart_response_model.dart';
import '../../data/models/cart_models/delete_cart_response_model.dart';
import '../../data/repo/cart_repo.dart';

class CartCubit extends Cubit<CartState> {
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  final CartRepo cartRepo;
  CartResponseModel? _cachedCart;

  CartCubit({required this.cartRepo}) : super(CartState.initial());

  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  Future<void> getCart() async {
    emit(CartState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartState.fail("Authentication token not found"));
        return;
      }
      final ApiResult<CartResponseModel> result = await cartRepo.getCart(token);
      result.when(
        success: (CartResponseModel data) {
          _cachedCart = data;
          emit(CartState.success(data));
        },
        failure: (error) => emit(CartState.fail(error)),
      );
    } catch (e) {
      emit(CartState.fail(e.toString()));
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    emit(CartState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartState.fail("Authentication token not found"));
        return;
      }
      final ApiResult<CartResponseModel> result = await cartRepo.addToCart(
        CartRequestModel(productId: productId, quantity: quantity),
        token,
      );
      result.when(
        success: (CartResponseModel data) {
          _cachedCart = data;
          emit(CartState.success(data));
        },
        failure: (error) => emit(CartState.fail(error)),
      );
    } catch (e) {
      emit(CartState.fail(e.toString()));
    }
  }

  Future<void> updateCart(String productId, int quantity) async {
    // 1. Emit updateQuantityLoading so only the tapped item shows a spinner —
    emit(CartState.updateQuantityLoading(productId));

    // 2. Optimistically patch the cached cart so the counter updates instantly
    //    without waiting for the server round-trip.
    if (_cachedCart != null) {
      final optimistic = _applyQuantityPatch(_cachedCart!, productId, quantity);
      _cachedCart = optimistic;
      emit(CartState.success(optimistic));
      // Re-emit the per-item loading flag so the UI keeps the spinner on that
      // item while the API call runs.
      emit(CartState.updateQuantityLoading(productId));
    }

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartState.fail("Authentication token not found"));
        return;
      }
      final ApiResult<CartResponseModel> result = await cartRepo.updateCart(
        productId,
        CartRequestModel(quantity: quantity),
        token,
      );
      result.when(
        success: (CartResponseModel data) {
          _cachedCart = data;
          emit(CartState.success(data));
        },
        failure: (error) {
          if (_cachedCart != null) emit(CartState.success(_cachedCart!));
          emit(CartState.fail(error));
        },
      );
    } catch (e) {
      if (_cachedCart != null) emit(CartState.success(_cachedCart!));
      emit(CartState.fail(e.toString()));
    }
  }

  Future<void> removeFromCart(String productId) async {
    emit(CartState.updateQuantityLoading(productId));
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartState.fail("Authentication token not found"));
        return;
      }
      final ApiResult<DeleteCartResponseModel> result =
          await cartRepo.removeFromCart(productId, token);
      result.when(
        success: (DeleteCartResponseModel data) {
          emit(CartState.success(data));
        },
        failure: (error) => emit(CartState.fail(error)),
      );
    } catch (e) {
      emit(CartState.fail(e.toString()));
    }
  }

  Future<void> removeAllCart() async {
    emit(CartState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartState.fail("Authentication token not found"));
        return;
      }
      final ApiResult<MessageModel> result = await cartRepo.removeAllCart(token);
      result.when(
        success: (MessageModel data) {
          _cachedCart = null;
          emit(CartState.success(data));
        },
        failure: (error) => emit(CartState.fail(error)),
      );
    } catch (e) {
      emit(CartState.fail(e.toString()));
    }
  }

  CartResponseModel _applyQuantityPatch(
    CartResponseModel cart,
    String productId,
    int newQuantity,
  ) {
    List<Item> patchItems(List<Item>? items) {
      return (items ?? []).map((item) {
        if (item.product?.pId == productId) {
          final price = item.priceAtAddTime ?? item.product?.price ?? 0;
          return Item(
            product: item.product,
            quantity: newQuantity,
            priceAtAddTime: item.priceAtAddTime,
            subtotal: price * newQuantity,
            iId: item.iId,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
          );
        }
        return item;
      }).toList();
    }

    final patchedItems = patchItems(cart.items);
    final patchedSubOrders = (cart.subOrders ?? []).map((sub) {
      return CartSubOrder(
        sellerName: sub.sellerName,
        items: patchItems(sub.items),
        subTotal: patchItems(sub.items).fold(
          0,
          (sum, i) =>
              sum! +
              (i.subtotal ??
                  (i.priceAtAddTime ?? i.product?.price ?? 0) *
                      (i.quantity ?? 1)),
        ),
      );
    }).toList();

    final newTotal = patchedItems.fold<int>(
      0,
      (sum, i) =>
          sum +
          (i.subtotal ??
              (i.priceAtAddTime ?? i.product?.price ?? 0) * (i.quantity ?? 1)),
    );

    return CartResponseModel(
      cId: cart.cId,
      user: cart.user,
      items: patchedItems,
      subOrders: patchedSubOrders,
      totalAmount: newTotal,
      createdAt: cart.createdAt,
      updatedAt: cart.updatedAt,
      iV: cart.iV,
    );
  }
}
