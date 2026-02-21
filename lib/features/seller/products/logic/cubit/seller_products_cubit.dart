import 'package:bloc/bloc.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_state.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../data/models/product_model_response.dart';
import '../../data/repo/seller_product_repo.dart';

class SellerProductsCubit extends Cubit<SellerProductsState> {
  final SellerProductRepo sellerProductRepo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  SellerProductsCubit({required this.sellerProductRepo})
    : super(SellerProductsState.initial());
  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  Future<void> getProducts() async {
    emit(SellerProductsState.loading());
    final token = await _getToken();
    if (token == null) {
      emit(SellerProductsState.fail('Token not found'));
      return;
    }

    try {
      final List<ProductModel> response = await sellerProductRepo
          .getProductsSeller(token);
      emit(SellerProductsState.success(response));
    } catch (e) {
      emit(SellerProductsState.fail(e.toString()));
    }
  }

  Future<void> deleteProduct(String productId) async {
    emit(SellerProductsState.loading());
    final token = await _getToken();
    if (token == null) {
      emit(SellerProductsState.fail('Token not found'));
      return;
    }
    try {
      await sellerProductRepo.deleteProduct(token, productId);
      await getProducts();
    } catch (e) {
      emit(SellerProductsState.fail(e.toString()));
    }
  }
}
