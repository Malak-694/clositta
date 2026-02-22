import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/view_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_state.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_key.dart';
import '../../data/models/product_models/product_response_model.dart';

class ViewProductsCubit extends Cubit<ViewProductsState> {
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  final ViewProductsRepo viewProductsRepo;

  ViewProductsCubit({required this.viewProductsRepo})
    : super(ViewProductsState.initial());

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

  /// No local filtering or caching; backend provides filtered lists.
  Future<void> invalidateCache({String? type}) async {
    // no-op kept for compatibility
    return;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
