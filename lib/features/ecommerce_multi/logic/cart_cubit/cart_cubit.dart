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
        emit(CartState.success(data));
      },
      failure: (error) {
        emit(CartState.fail(error));
      },
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
      final ApiResult<CartResponseModel> result = await cartRepo.addToCart(CartRequestModel(productId: productId, quantity: quantity), token);
    result.when(
      success: (CartResponseModel data) {
        emit(CartState.success(data));
      },
      failure: (error) {
        emit(CartState.fail(error));
      },
    );
    } catch (e) {
      emit(CartState.fail(e.toString()));
    }
    
  }
   Future<void> updateCart(String productId, int quantity) async {
    emit(CartState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartState.fail("Authentication token not found"));
        return;
      }
      final ApiResult<CartResponseModel> result = await cartRepo.updateCart(productId, CartRequestModel( quantity: quantity), token);
    result.when(
      success: (CartResponseModel data) {
        emit(CartState.success(data));
      },
      failure: (error) {
        emit(CartState.fail(error));
      },
    );
    } catch (e) {
      emit(CartState.fail(e.toString()));
    }
    
  }
   Future<void> removeFromCart(String productId) async {
    emit(CartState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartState.fail("Authentication token not found"));
        return;
      }
      final ApiResult<DeleteCartResponseModel> result = await cartRepo.removeFromCart(productId, token);
    result.when(
      success: (DeleteCartResponseModel data) {
        emit(CartState.success(data));
      },
      failure: (error) {
        emit(CartState.fail(error));
      },
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
        emit(CartState.success(data));
      },
      failure: (error) {
        emit(CartState.fail(error));
      },
    );
    } catch (e) {
      emit(CartState.fail(e.toString()));
    }
    
  }
}
