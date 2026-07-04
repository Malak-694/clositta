import 'package:bloc/bloc.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_page_ui_model.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/product_search_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/view_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_state.dart';

import '../../data/models/product_models/product_response_model.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';

class ViewProductsCubit extends Cubit<ViewProductsState<ProductPageData>> {
  final ViewProductsRepo viewProductsRepo;
  final ProductSearchRepo productSearchRepo;
  final prefs = getIt<SharedPrefHelper>();

  ViewProductsCubit({
    required this.viewProductsRepo,
    required this.productSearchRepo,
  }) : super(const ViewProductsState.initial());

  // stored filters, reused by loadMore()
  String? _token;
  String? _category;
  double? _minPrice;
  double? _maxPrice;
  bool? _inStock;
  String? _sellerId;
  String? _search;
  String? _type;
  String? _season;
  String? _occasion;
  String? _gender;

  List<ProductModelBuyer> _products = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  Future<void> getProductsBuyer({
    required String token,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    String? sellerId,
    String? search,
    String? type,
    String? season,
    String? occasion,
    String? gender,
  }) async {
    _token = token;
    _category = category;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _inStock = inStock;
    _sellerId = sellerId;
    _search = search;
    _type = type;
    _season = season;
    _occasion = occasion;
    _gender = gender;

    _currentPage = 1;
    _hasMore = true;
    _products = [];

    emit(const ViewProductsState.loading());
    await _fetchPage();
  }

  Future<void> loadMore() async {
    if (_isFetching || !_hasMore) return;

    // keep showing current products, just flag isLoadingMore
    emit(ViewProductsState.success(
      ProductPageData(
        products: _products,
        hasMore: _hasMore,
        isLoadingMore: true,
      ),
    ));

    await _fetchPage();
  }

  Future<void> _fetchPage() async {
    _isFetching = true;
    try {
      final response = await viewProductsRepo.getProductsBuyer(
        token: _token!,
        category: _category,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        inStock: _inStock,
        sellerId: _sellerId,
        search: _search,
        type: _type,
        season: _season,
        occasion: _occasion,
        gender: _gender,
        page: _currentPage,
      );

      response.when(
        success: (data) {
          _products = [..._products, ...data.products];
          _hasMore = data.hasMore;
          _currentPage++;
          emit(ViewProductsState.success(
            ProductPageData(
              products: _products,
              hasMore: _hasMore,
              isLoadingMore: false,
            ),
          ));
        },
        failure: (error) {
          emit(ViewProductsState.fail(error));
        },
      );
    } catch (e) {
      emit(ViewProductsState.fail(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> searchByText({required String query}) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(const ViewProductsState.fail('Please enter a search term.'));
      return;
    }
    try {
      emit(const ViewProductsState.loading());
      final body = {'query': trimmedQuery};
      final response = await productSearchRepo.searchByText(body: body);
      response.when(
        success: (results) {
          final products = results
              .map((r) => r.product)
              .whereType<ProductModelBuyer>()
              .toList();
          _products = products;
          _hasMore = false;
          emit(ViewProductsState.success(
            ProductPageData(products: products, hasMore: false),
          ));
        },
        failure: (error) => emit(ViewProductsState.fail(error)),
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
      emit(const ViewProductsState.loading());
      final response = await productSearchRepo.searchByImage(imagePath: imagePath);
      response.when(
        success: (results) {
          final products = results
              .map((r) => r.product)
              .whereType<ProductModelBuyer>()
              .toList();
          _products = products;
          _hasMore = false;
          emit(ViewProductsState.success(
            ProductPageData(products: products, hasMore: false),
          ));
        },
        failure: (error) => emit(ViewProductsState.fail(error)),
      );
    } catch (e) {
      emit(ViewProductsState.fail(e.toString()));
    }
  }
}