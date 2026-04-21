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

  OrderMangementCubit({required this.repo}) : super(OrderMangementState.initial());

  Future<void> getAllOrdersSeller({String? status}) async {
    _lastStatusFilter = status;
    emit(const OrderMangementState.loading());
    await _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final token = await prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const OrderMangementState.fail("Authentication token not found"));
        return;
      }

      final ApiResult<List<OrderSellerResponseModel>> result =
          await repo.getAllOrdersSeller(token, status: _lastStatusFilter);

      result.when(
        success: (orders) => emit(OrderMangementState.success(orders)),
        failure: (error) => emit(OrderMangementState.fail(error)),
      );
    } catch (e) {
      emit(OrderMangementState.fail("please try again later"));
    }
  }

  Future<void> updateOrderStatusSeller({
    required String orderId,
    String? orderStatus,
    String? paymentStatus,
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
            OrderUpdateSellerRequestModel(
              orderStatus: orderStatus,
              paymentStatus: paymentStatus,
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
