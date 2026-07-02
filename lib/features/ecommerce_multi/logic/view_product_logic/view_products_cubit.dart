import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/product_search_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/view_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_state.dart';

import '../../data/models/product_models/product_response_model.dart';
import '../../data/models/product_models/product_search_response_model.dart';

class ViewProductsCubit extends Cubit<ViewProductsState> {
  final ViewProductsRepo viewProductsRepo;
  final ProductSearchRepo productSearchRepo;

  // Full list of fetched products
  List<ProductModelBuyer> _allProducts = [];
  // Filtering criteria
  String? _selectedSeason;
  String? _selectedOccasion;
  String? _selectedType;

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
      // final roleVal = _prefs.getSecureData(SharedPrefKey.role);
      // final String? userRole = roleVal as String?;
      // final effectiveType =
      //     type ?? (userRole == 'tailor' ? 'Material' : 'Clothes');

      emit(ViewProductsState.loading());
      final response = await viewProductsRepo.getProductsBuyer(
        token: token,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        inStock: inStock,
        sellerId: sellerId,
        search: search,
        type: type,
      );

      response.when(
        success: (List<ProductModelBuyer> products) {
          // Keep the full list for local filtering
          _allProducts = products;
          // Apply any existing filters before emitting
          _applyFilters();
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

  /// Local filtering methods for season and occasion
  void filterBySeason(String? season) {
    _selectedSeason = season;
    _applyFilters();
  }

  void filterByOccasion(String? occasion) {
    _selectedOccasion = occasion;
    _applyFilters();
  }

  void filterByType(String? type) {
    _selectedType = type;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = _allProducts;
    if (_selectedSeason != null && _selectedSeason!.toLowerCase() != 'all') {
      filtered = filtered
          .where(
            (p) =>
                p.season != null &&
                p.season!.toLowerCase() == _selectedSeason!.toLowerCase(),
          )
          .toList();
    }
    if (_selectedOccasion != null &&
        _selectedOccasion!.toLowerCase() != 'all') {
      filtered = filtered
          .where(
            (p) =>
                p.occasion != null &&
                p.occasion!.toLowerCase() == _selectedOccasion!.toLowerCase(),
          )
          .toList();
    }
    if (_selectedType != null && _selectedType!.toLowerCase() != 'all') {
      filtered = filtered
          .where(
            (p) =>
                p.type != null &&
                p.type!.toLowerCase() == _selectedType!.toLowerCase(),
          )
          .toList();
    }
    emit(ViewProductsState.success(filtered));
  }

  /// No local filtering or caching; backend provides filtered lists.
  Future<void> invalidateCache({String? type}) async {
    // no-op kept for compatibility
    return;
  }
}
