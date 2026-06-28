import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/product_search_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/view_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_state.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_key.dart';
import '../../data/models/product_models/product_response_model.dart';
import '../../data/models/product_models/product_search_response_model.dart';

class ViewProductsCubit extends Cubit<ViewProductsState> {
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  final ViewProductsRepo viewProductsRepo;
  final ProductSearchRepo productSearchRepo;

  ViewProductsCubit({
    required this.viewProductsRepo,
    required this.productSearchRepo,
  }) : super(ViewProductsState.initial());

  Future<void> getProductsBuyer({
    required String token,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    String? sellerId,
    String? search,
    String? type,
  }) async {
    try {
      final roleVal = _prefs.getData(SharedPrefKey.role);
      final String userRole = (roleVal is String) ? roleVal : '';
      final effectiveType =
          type ?? (userRole.toLowerCase() == 'tailor' ? 'material' : 'Clothes');

      emit(ViewProductsState.loading());
      final response = await viewProductsRepo.getProductsBuyer(
        token: token,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        inStock: inStock,
        sellerId: sellerId,
        search: search,
        type: effectiveType,
      );

      response.when(
        success: (List<ProductModelBuyer> products) {
          emit(ViewProductsState.success(products));
        },
        failure: (String error) {
          emit(ViewProductsState.fail(error));
        },
      );
    } catch (e) {
      emit(ViewProductsState.fail(e.toString()));
    }
  }

  Future<void> searchByText({required String query}) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(const ViewProductsState.fail('Please enter a search term.'));
      return;
    }
    try {
      emit(ViewProductsState.loading());
      final Map<String, dynamic> body = {};
      body['query'] = trimmedQuery;
      final ApiResult<List<ProductSearchResponseModel>> response =
          await productSearchRepo.searchByText(body: body);
      response.when(
        success: (List<ProductSearchResponseModel> searchResults) {
          final products = searchResults
              .map((result) => result.product)
              .whereType<ProductModelBuyer>()
              .toList();
          emit(ViewProductsState.success(products));
        },
        failure: (String error) {
          emit(ViewProductsState.fail(error));
        },
      );
    } catch (e) {
      emit(ViewProductsState.fail(e.toString()));
    }
  }

  Future<void> searchByImage({required String imagePath}) async {
    if (imagePath.trim().isEmpty) {
      emit(const ViewProductsState.fail('Please select an image.'));
      return;
    }

    try {
      emit(ViewProductsState.loading());
      final response = await productSearchRepo.searchByImage(
        imagePath: imagePath,
      );
      response.when(
        success: (List<ProductSearchResponseModel> searchResults) {
          final products = searchResults
              .map((result) => result.product)
              .whereType<ProductModelBuyer>()
              .toList();
          emit(ViewProductsState.success(products));
        },
        failure: (String error) {
          emit(ViewProductsState.fail(error));
        },
      );
    } catch (e) {
      emit(ViewProductsState.fail(e.toString()));
    }
  }

  /// No local filtering or caching; backend provides filtered lists.
  Future<void> invalidateCache({String? type}) async {
    // no-op kept for compatibility
    return;
  }
}
