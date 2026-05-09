import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_result.dart' as api;
import 'package:chicora/features/ecommerce_multi/data/models/order_models/cancel_order_request_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_request_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/pay_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/place_order_success.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/order_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepo repo;
  final prefs = getIt<SharedPrefHelper>();

  OrderCubit(this.repo) : super(OrderState.initial());

  Future<void> placeOrder(OrderRequestModel body) async {
    emit(const OrderState.loading());
    try {
      final token = await prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const OrderState.fail("Authentication token not found"));
        return;
      }

      final result = await repo.placeOrder(token, body);
      switch (result) {
        case api.Failure(:final message):
          emit(OrderState.fail(message));
        case api.Success(data: final OrderResponseModel response):
          final orderId = response.order?.id ?? '';
          final wantsCredit =
              body.paymentMethod == OrderRequestModel.paymentCredit;

          if (wantsCredit) {
            if (orderId.isEmpty) {
              emit(
                const OrderState.fail(
                  'Order was created but payment could not be started.',
                ),
              );
              return;
            }
            final payResult = await repo.initiatePayment(token, orderId);
            switch (payResult) {
              case api.Failure(:final message):
                emit(OrderState.fail(message));
              case api.Success(data: final PaymentInitiateResponseModel pay):
                final url = pay.iframeUrl;
                if (url == null || url.trim().isEmpty) {
                  emit(
                    const OrderState.fail('Payment link was not returned.'),
                  );
                  return;
                }
                emit(
                  OrderState.success(
                    PlaceOrderSuccess(
                      message: response.message,
                      orderId: orderId,
                      paymentIframeUrl: url.trim(),
                    ),
                  ),
                );
            }
            return;
          }

          emit(
            OrderState.success(
              PlaceOrderSuccess(
                message: response.message,
                orderId: orderId.isEmpty ? null : orderId,
              ),
            ),
          );
      }
    } catch (e) {
      emit(OrderState.fail("please try again later"));
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    emit(const OrderState.loading());
    try {
      final token = await prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const OrderState.fail("Authentication token not found"));
        return;
      }

      final api.ApiResult<MessageModel> result = await repo.cancelOrder(
        token,
        orderId,
        CancelOrderRequestModel(reason: reason),
      );
      result.when(
        success: (MessageModel response) {
          emit(OrderState.success(response));
        },
        failure: (error) {
          emit(OrderState.fail(error));
        },
      );
    } catch (e) {
      emit(OrderState.fail("please try again later"));
    }
  }

  Future<void> cancelSubOrder(
    String orderId,
    String subOrderId,
    String reason,
  ) async {
    emit(const OrderState.loading());
    try {
      final token = await prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const OrderState.fail("Authentication token not found"));
        return;
      }

      final api.ApiResult<MessageModel> result = await repo.cancelSubOrder(
        token,
        orderId,
        subOrderId,
        CancelOrderRequestModel(reason: reason),
      );
      result.when(
        success: (MessageModel response) {
          emit(OrderState.success(response));
        },
        failure: (error) {
          emit(OrderState.fail(error));
        },
      );
    } catch (e) {
      emit(OrderState.fail("please try again later"));
    }
  }

  Future<void> getMyOrders() async {
    emit(const OrderState.loading());
    try {
      final token = await prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const OrderState.fail("Authentication token not found"));
        return;
      }

      final api.ApiResult<List<OrderDataModel>> result = await repo.getMyOrders(
        token,
      );
      result.when(
        success: (orders) => emit(OrderState.success(orders)),
        failure: (error) => emit(OrderState.fail(error)),
      );
    } catch (e) {
      emit(OrderState.fail("please try again later"));
    }
  }

  Future<void> getOrderById(String orderId) async {
    emit(const OrderState.loading());
    try {
      final token = await prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const OrderState.fail("Authentication token not found"));
        return;
      }

      final api.ApiResult<OrderDataModel> result = await repo.getOrderById(
        token,
        orderId,
      );
      result.when(
        success: (order) => emit(OrderState.success(order)),
        failure: (error) => emit(OrderState.fail(error)),
      );
    } catch (e) {
      emit(OrderState.fail("please try again later"));
    }
  }
}
