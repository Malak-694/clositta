import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/seller/orders/data/models/order_seller_response_model.dart';
import 'package:chicora/features/seller/orders/data/models/order_update_seller_request_model.dart';
import 'package:chicora/features/seller/orders/data/models/order_update_seller_response.dart';
import 'package:chicora/features/seller/orders/data/repo/order_mangement_repo.dart';
import 'package:chicora/features/seller/orders/logic/cubit/order_mangement_state.dart';

class OrderMangementCubit extends Cubit<OrderMangementState> {
  final OrderMangementRepo repo;
  final prefs = getIt<SharedPrefHelper>();

  String? _lastStatusFilter;
  List<OrderSellerResponseModel>? _cachedAllOrders;

  OrderMangementCubit({required this.repo}) : super(OrderMangementState.initial());

  /// Loads every seller order from the API (no server-side status filter), caches
  /// the full list, then emits [success] with orders matching [status].
  ///
  /// When [forceRefresh] is false and a cache exists (for example after changing
  /// the filter chip), only local filtering runs—no network round trip.
  Future<void> getAllOrdersSeller({String? status, bool forceRefresh = false}) async {
    _lastStatusFilter = status;
    final cached = _cachedAllOrders;
    if (!forceRefresh && cached != null) {
      emit(OrderMangementState.success(_filterOrdersByStatus(cached, _lastStatusFilter)));
      return;
    }

    emit(const OrderMangementState.loading());
    await _fetchOrders();
  }

  List<OrderSellerResponseModel> _filterOrdersByStatus(
    List<OrderSellerResponseModel> orders,
    String? status,
  ) {
    if (status == null || status.isEmpty) return List<OrderSellerResponseModel>.from(orders);
    final needle = status.toLowerCase();
    return orders
        .where((o) => (o.resolvedOrderStatus ?? '').toLowerCase() == needle)
        .toList();
  }

  Future<void> _fetchOrders() async {
    try {
      final token = await prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const OrderMangementState.fail("Authentication token not found"));
        return;
      }

      final ApiResult<List<OrderSellerResponseModel>> result =
          await repo.getAllOrdersSeller(token);

      result.when(
        success: (orders) {
          _cachedAllOrders = orders;
          emit(
            OrderMangementState.success(
              _filterOrdersByStatus(orders, _lastStatusFilter),
            ),
          );
        },
        failure: (error) => emit(OrderMangementState.fail(error)),
      );
    } catch (e) {
      emit(OrderMangementState.fail("please try again later"));
    }
  }

  Future<void> updateOrderStatusSeller({
    required String orderId,
    required String suborderId,
    String? orderStatus,
  }) async {
    emit(const OrderMangementState.loading());
    try {
      final token = await prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const OrderMangementState.fail("Authentication token not found"));
        return;
      }

      final ApiResult<OrderUpdateSellerResponseModel> result =
          await repo.updateOrderStatusSeller(
            token,
            orderId,
            suborderId,
            OrderUpdateSellerRequestModel(
              orderStatus: orderStatus,
            ),
          );

      result.when(
        success: (_) async {
          await _fetchOrders();
        },
        failure: (error) => emit(OrderMangementState.fail(error)),
      );
    } catch (e) {
      emit(OrderMangementState.fail("please try again later"));
    }
  }
}
