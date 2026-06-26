import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/models/cart_models/cart_request_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/cart_models/cart_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/cart_models/delete_cart_response_model.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/cart_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepo extends Mock implements CartRepo {}
class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

void main() {
  late MockCartRepo mockCartRepo;
  late MockSharedPrefHelper mockPrefs;
  late CartCubit cartCubit;

  setUpAll(() {
    registerFallbackValue(CartRequestModel(productId: '', quantity: 1));
  });

  final fakeCartResponse = CartResponseModel(
    cId: "cart-123",
    user: "user-123",
    items: [],
    subOrders: [],
    totalAmount: 0,
  );

  setUp(() {
    mockCartRepo = MockCartRepo();
    mockPrefs = MockSharedPrefHelper();
    
    // Register mock dependencies
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    
    cartCubit = CartCubit(cartRepo: mockCartRepo);
  });

  tearDown(() {
    cartCubit.close();
    getIt.reset();
  });

  group('getCart', () {
    blocTest<CartCubit, CartState>(
      'emits [Loading, Success] when token is found and API succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockCartRepo.getCart(any()))
            .thenAnswer((_) async => ApiResult.success(fakeCartResponse));
        return cartCubit;
      },
      act: (cubit) => cubit.getCart(),
      expect: () => [
        const CartState.loading(),
        CartState<dynamic>.success(fakeCartResponse),
      ],
    );

    blocTest<CartCubit, CartState>(
      'emits [Loading, Fail] when token is null',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => null);
        return cartCubit;
      },
      act: (cubit) => cubit.getCart(),
      expect: () => [
        const CartState.loading(),
        const CartState.fail('Authentication token not found'),
      ],
    );

    blocTest<CartCubit, CartState>(
      'emits [Loading, Fail] when API fails',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockCartRepo.getCart(any()))
            .thenAnswer((_) async => const ApiResult.failure('Failed to fetch cart'));
        return cartCubit;
      },
      act: (cubit) => cubit.getCart(),
      expect: () => [
        const CartState.loading(),
        const CartState.fail('Failed to fetch cart'),
      ],
    );
  });

  group('addToCart', () {
    blocTest<CartCubit, CartState>(
      'emits [Loading, Success] when item is added successfully',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockCartRepo.addToCart(any(), any()))
            .thenAnswer((_) async => ApiResult.success(fakeCartResponse));
        return cartCubit;
      },
      act: (cubit) => cubit.addToCart('product-1', 2),
      expect: () => [
        const CartState.loading(),
        CartState<dynamic>.success(fakeCartResponse),
      ],
    );
  });

  group('updateCart', () {
    blocTest<CartCubit, CartState>(
      'emits [Loading, Success] when item quantity is updated successfully',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockCartRepo.updateCart(any(), any(), any()))
            .thenAnswer((_) async => ApiResult.success(fakeCartResponse));
        return cartCubit;
      },
      act: (cubit) => cubit.updateCart('product-1', 3),
      expect: () => [
        const CartState.loading(),
        CartState<dynamic>.success(fakeCartResponse),
      ],
    );
  });

  group('removeFromCart', () {
    final fakeDeleteResponse = DeleteCartResponseModel(
      message: 'Item removed',
      cart: fakeCartResponse,
    );

    blocTest<CartCubit, CartState>(
      'emits [Loading, Success] when item is removed from cart',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockCartRepo.removeFromCart(any(), any()))
            .thenAnswer((_) async => ApiResult.success(fakeDeleteResponse));
        return cartCubit;
      },
      act: (cubit) => cubit.removeFromCart('product-1'),
      expect: () => [
        const CartState.loading(),
        CartState<dynamic>.success(fakeDeleteResponse),
      ],
    );
  });

  group('removeAllCart', () {
    final fakeMessageResponse = MessageModel(message: 'Cart cleared');

    blocTest<CartCubit, CartState>(
      'emits [Loading, Success] when cart is cleared',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockCartRepo.removeAllCart(any()))
            .thenAnswer((_) async => ApiResult.success(fakeMessageResponse));
        return cartCubit;
      },
      act: (cubit) => cubit.removeAllCart(),
      expect: () => [
        const CartState.loading(),
        CartState<dynamic>.success(fakeMessageResponse),
      ],
    );
  });
}
