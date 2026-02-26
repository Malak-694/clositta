import 'package:bloc/bloc.dart';
import 'package:chicora/core/networking/api_result.dart';
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

  Future<void> addProduct({
    required String name,
    required String description,
    required String price,
    required String stock,
    required String category,
    required String type,
    required String imagePath,
  }) async {
    emit(SellerProductsState.loading());
    final token = await _getToken();
    if (token == null) {
      emit(SellerProductsState.fail('Token not found'));
      return;
    }
    try {
      final response = await sellerProductRepo.addProduct(
        token: token,
        name: name,
        description: description,
        price: price,
        stock: stock,
        category: category,
        type: type,
        imagePath: imagePath,
      );

      response.when(
        success: (_) => emit(SellerProductsState.success(response)),
        failure: (error) => emit(SellerProductsState.fail(error)),
      );
    } catch (e) {
      emit(SellerProductsState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to add product. Please try again.",
      ));
    }
  }

  Future<void> updateProduct({
    required String productId,
    required String name,
    required String description,
    required String price,
    required String stock,
    required String category,
    required String type,
    String? imagePath,
  }) async {
    emit(SellerProductsState.loading());
    final token = await _getToken();
    if (token == null) {
      emit(SellerProductsState.fail('Token not found'));
      return;
    }
    try {
      final response = await sellerProductRepo.updateProduct(
        token: token,
        productId: productId,
        name: name,
        description: description,
        price: price,
        stock: stock,
        category: category,
        type: type,
        imagePath: imagePath,
      );

      response.when(
        success: (_) => emit(SellerProductsState.success(response)),
        failure: (error) => emit(SellerProductsState.fail(error)),
      );
    } catch (e) {
      emit(SellerProductsState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to update product. Please try again.",
      ));
    }
  }
}
