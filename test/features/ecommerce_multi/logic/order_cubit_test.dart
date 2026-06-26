import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/cancel_order_request_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_request_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/order_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/pay_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/order_models/place_order_success.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/order_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderRepo extends Mock implements OrderRepo {}
class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

void main() {
  late MockOrderRepo mockOrderRepo;
  late MockSharedPrefHelper mockPrefs;
  late OrderCubit orderCubit;

  setUpAll(() {
    registerFallbackValue(OrderRequestModel());
    registerFallbackValue(CancelOrderRequestModel(reason: ''));
  });

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    mockPrefs = MockSharedPrefHelper();
    
    // Register mock dependencies
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    
    orderCubit = OrderCubit(mockOrderRepo);
  });

  tearDown(() {
    orderCubit.close();
    getIt.reset();
  });

  final fakeOrderResponse = OrderResponseModel(
    message: "Order placed successfully",
    order: OrderDataModel(id: "order-123"),
  );

  group('placeOrder', () {
    blocTest<OrderCubit, OrderState>(
      'emits [Loading, Success] when cash on delivery is successful',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockOrderRepo.placeOrder(any(), any()))
            .thenAnswer((_) async => ApiResult.success(fakeOrderResponse));
        return orderCubit;
      },
      act: (cubit) => cubit.placeOrder(OrderRequestModel(
        paymentMethod: OrderRequestModel.paymentCashOnDelivery,
      )),
      expect: () => [
        const OrderState.loading(),
        isA<OrderState>().having(
          (s) => s.maybeWhen(
            success: (data) => data,
            orElse: () => null,
          ),
          'success data',
          isA<PlaceOrderSuccess>()
              .having((p) => p.message, 'message', 'Order placed successfully')
              .having((p) => p.orderId, 'orderId', 'order-123')
              .having((p) => p.paymentIframeUrl, 'paymentIframeUrl', isNull),
        ),
      ],
    );

    blocTest<OrderCubit, OrderState>(
      'emits [Loading, Success] with payment URL when credit payment is successful',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockOrderRepo.placeOrder(any(), any()))
            .thenAnswer((_) async => ApiResult.success(fakeOrderResponse));
        when(() => mockOrderRepo.initiatePayment(any(), any()))
            .thenAnswer((_) async => ApiResult.success(PaymentInitiateResponseModel(
                  iframeUrl: 'https://pay.iframe.url',
                  paymentKey: 'key-123',
                )));
        return orderCubit;
      },
      act: (cubit) => cubit.placeOrder(OrderRequestModel(
        paymentMethod: OrderRequestModel.paymentCredit,
      )),
      expect: () => [
        const OrderState.loading(),
        isA<OrderState>().having(
          (s) => s.maybeWhen(
            success: (data) => data,
            orElse: () => null,
          ),
          'success data with iframeUrl',
          isA<PlaceOrderSuccess>()
              .having((p) => p.message, 'message', 'Order placed successfully')
              .having((p) => p.orderId, 'orderId', 'order-123')
              .having((p) => p.paymentIframeUrl, 'paymentIframeUrl', 'https://pay.iframe.url'),
        ),
      ],
    );
  });

  group('cancelOrder', () {
    blocTest<OrderCubit, OrderState>(
      'emits [Loading, Success] when order cancellation succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockOrderRepo.cancelOrder(any(), any(), any()))
            .thenAnswer((_) async => ApiResult.success(MessageModel(message: 'Cancelled')));
        return orderCubit;
      },
      act: (cubit) => cubit.cancelOrder('order-123', 'Changed my mind'),
      expect: () => [
        const OrderState.loading(),
        isA<OrderState>().having(
          (s) => s.maybeWhen(
            success: (data) => (data as MessageModel).message,
            orElse: () => null,
          ),
          'success message',
          'Cancelled',
        ),
      ],
    );
  });

  group('getMyOrders', () {
    blocTest<OrderCubit, OrderState>(
      'emits [Loading, Success] when loading my orders succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockOrderRepo.getMyOrders(any()))
            .thenAnswer((_) async => ApiResult.success(<OrderDataModel>[]));
        return orderCubit;
      },
      act: (cubit) => cubit.getMyOrders(),
      expect: () => [
        const OrderState.loading(),
        isA<OrderState>().having(
          (s) => s.maybeWhen(
            success: (data) => data,
            orElse: () => null,
          ),
          'success list',
          isEmpty,
        ),
      ],
    );
  });
}
