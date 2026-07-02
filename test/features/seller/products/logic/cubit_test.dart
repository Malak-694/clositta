import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/data/repo/seller_product_repo.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_state.dart'
    hide Success;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSellerProductRepo extends Mock implements SellerProductRepo {}

class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

void main() {
  late MockSellerProductRepo mockRepo;
  late MockSharedPrefHelper mockPrefs;
  late SellerProductsCubit cubit;

  final fakeProduct = ProductModel(
    ratingDistribution: {'1': 0, '2': 0, '3': 1, '4': 2, '5': 5},
    id: 'test-product-id-1',
    seller: 'test-seller-id-1',
    name: 'Blue Cotton Fabric',
    description: 'High quality cotton fabric',
    price: 12.99,
    stock: 500,
    category: 'Fabric',
    type: 'Cotton',
    imageUrl: 'https://via.placeholder.com/100',
    imageFileId: 'file-id-1',
    averageRating: 4.5,
    totalRatings: 8,
    ratings: [],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
    v: 0,
  );

  final fakeMessage = MessageModel(message: 'success');

  setUp(() {
    mockRepo = MockSellerProductRepo();
    mockPrefs = MockSharedPrefHelper();
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    cubit = SellerProductsCubit(sellerProductRepo: mockRepo);
  });

  tearDown(() {
    cubit.close();
    getIt.reset();
  });

  group('getProducts()', () {
    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, success] when token exists and API returns products',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');
        when(
          () => mockRepo.getProductsSeller(any()),
        ).thenAnswer((_) async => [fakeProduct]);
        return cubit;
      },
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const SellerProductsState.loading(),
        isA<SellerProductsState>().having(
          (s) => s.maybeWhen(
            success: (data) => (data as List).first,
            orElse: () => null,
          ),
          'first product name',
          isA<ProductModel>().having(
            (p) => p.name,
            'name',
            'Blue Cotton Fabric',
          ),
        ),
      ],
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when token is null',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const SellerProductsState.loading(),
        const SellerProductsState.fail('Token not found'),
      ],
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when the API throws an exception',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');
        when(
          () => mockRepo.getProductsSeller(any()),
        ).thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const SellerProductsState.loading(),
        isA<SellerProductsState<dynamic>>().having(
          (s) => s,
          'is fail',
          isA<Fail>(),
        ),
      ],
    );
  });

  group('deleteProduct()', () {
    blocTest<SellerProductsCubit, SellerProductsState>(
      'calls repo.deleteProduct then reloads the product list',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');
        when(
          () => mockRepo.deleteProduct(any(), any()),
        ).thenAnswer((_) async => MessageModel(message: 'deleted'));
        when(
          () => mockRepo.getProductsSeller(any()),
        ).thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.deleteProduct('p1'),
      expect: () => [
        const SellerProductsState.loading(),
        isA<SellerProductsState>().having(
          (s) => s.maybeWhen(success: (data) => data, orElse: () => null),
          'empty list',
          isEmpty,
        ),
      ],
      verify: (_) {
        verify(() => mockRepo.deleteProduct('fake-token-123', 'p1')).called(1);
      },
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when token is null',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => cubit.deleteProduct('p1'),
      expect: () => [
        const SellerProductsState.loading(),
        const SellerProductsState.fail('Token not found'),
      ],
    );
  });

  group('addProduct()', () {
    void callAddProduct(SellerProductsCubit c) => c.addProduct(
      name: 'Test Fabric',
      description: 'A nice fabric',
      price: '15.99',
      stock: '100',
      gender: 'Unisex',
      season: 'All',
      occasion: 'Casual',
      color: 'Red',
      category: 'Tops',
      type: 'Clothes',
      imagePath: '/fake/path/image.jpg',
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, success] when token exists and API succeeds',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');

        // Stub repo to return success — no real file IO
        when(
          () => mockRepo.addProduct(
            token: any(named: 'token'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            stock: any(named: 'stock'),
            category: any(named: 'category'),
            type: any(named: 'type'),
            gender: any(named: 'gender'),
            season: any(named: 'season'),
            occasion: any(named: 'occasion'),
            color: any(named: 'color'),
            imagePath: any(named: 'imagePath'),
          ),
        ).thenAnswer((_) async => ApiResult.success(fakeMessage));

        return cubit;
      },
      act: (cubit) => callAddProduct(cubit),
      expect: () => [
        const SellerProductsState.loading(),
        isA<SellerProductsState>().having(
          (s) => s.maybeWhen(success: (_) => true, orElse: () => false),
          'is success',
          true,
        ),
      ],
      verify: (_) {
        verify(
          () => mockRepo.addProduct(
            token: 'fake-token-123',
            name: 'Test Fabric',
            description: 'A nice fabric',
            price: '15.99',
            stock: '100',
            category: 'Tops',
            type: 'Clothes',
            gender: any(named: 'gender'),
            season: any(named: 'season'),
            occasion: any(named: 'occasion'),
            color: any(named: 'color'),
            imagePath: '/fake/path/image.jpg',
          ),
        ).called(1);
      },
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when token is null',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => callAddProduct(cubit),
      expect: () => [
        const SellerProductsState.loading(),
        const SellerProductsState.fail('Token not found'),
      ],
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when API returns a failure response',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');

        // Stub repo to return failure
        when(
          () => mockRepo.addProduct(
            token: any(named: 'token'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            stock: any(named: 'stock'),
            category: any(named: 'category'),
            type: any(named: 'type'),
            gender: any(named: 'gender'),
            season: any(named: 'season'),
            occasion: any(named: 'occasion'),
            color: any(named: 'color'),
            imagePath: any(named: 'imagePath'),
          ),
        ).thenAnswer((_) async => const ApiResult.failure('Server error: 500'));

        return cubit;
      },
      act: (cubit) => callAddProduct(cubit),
      expect: () => [
        const SellerProductsState.loading(),
        const SellerProductsState.fail('Server error: 500'),
      ],
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when repo throws an exception',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');
        when(
          () => mockRepo.addProduct(
            token: any(named: 'token'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            stock: any(named: 'stock'),
            category: any(named: 'category'),
            type: any(named: 'type'),
            gender: any(named: 'gender'),
            season: any(named: 'season'),
            occasion: any(named: 'occasion'),
            color: any(named: 'color'),
            imagePath: any(named: 'imagePath'),
          ),
        ).thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (cubit) => callAddProduct(cubit),
      expect: () => [
        const SellerProductsState.loading(),
        isA<SellerProductsState<dynamic>>().having(
          (s) => s,
          'is fail',
          isA<Fail>(),
        ),
      ],
    );
  });

  group('updateProduct()', () {
    void callUpdateProduct(SellerProductsCubit c) => c.updateProduct(
      productId: 'test-product-id-1',
      name: 'Updated Fabric',
      description: 'Updated description',
      price: '20.00',
      stock: '300',
      category: 'Bottoms',
      type: 'Clothes',
      gender: 'Unisex',
      season: 'All',
      occasion: 'Casual',
      color: 'Red',
      imagePath: null,
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, success] when token exists and API succeeds',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');

        when(
          () => mockRepo.updateProduct(
            token: any(named: 'token'),
            productId: any(named: 'productId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            stock: any(named: 'stock'),
            category: any(named: 'category'),
            type: any(named: 'type'),
            gender: any(named: 'gender'),
            season: any(named: 'season'),
            occasion: any(named: 'occasion'),
            color: any(named: 'color'),
            imagePath: any(named: 'imagePath'),
          ),
        ).thenAnswer((_) async => ApiResult.success(fakeMessage));

        return cubit;
      },
      act: (cubit) => callUpdateProduct(cubit),
      expect: () => [
        const SellerProductsState.loading(),
        isA<SellerProductsState>().having(
          (s) => s.maybeWhen(success: (_) => true, orElse: () => false),
          'is success',
          true,
        ),
      ],
      verify: (_) {
        verify(
          () => mockRepo.updateProduct(
            token: 'fake-token-123',
            productId: 'test-product-id-1',
            name: 'Updated Fabric',
            description: 'Updated description',
            price: '20.00',
            stock: '300',
            category: 'Bottoms',
            type: 'Clothes',
            gender: 'Unisex',
            season: 'All',
            occasion: 'Casual',
            color: 'Red',
            imagePath: null,
          ),
        ).called(1);
      },
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when token is null',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => callUpdateProduct(cubit),
      expect: () => [
        const SellerProductsState.loading(),
        const SellerProductsState.fail('Token not found'),
      ],
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when API returns a failure response',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');

        when(
          () => mockRepo.updateProduct(
            token: any(named: 'token'),
            productId: any(named: 'productId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            stock: any(named: 'stock'),
            category: any(named: 'category'),
            type: any(named: 'type'),
            gender: any(named: 'gender'),
            season: any(named: 'season'),
            occasion: any(named: 'occasion'),
            color: any(named: 'color'),
            imagePath: any(named: 'imagePath'),
          ),
        ).thenAnswer((_) async => const ApiResult.failure('Update failed'));

        return cubit;
      },
      act: (cubit) => callUpdateProduct(cubit),
      expect: () => [
        const SellerProductsState.loading(),
        const SellerProductsState.fail('Update failed'),
      ],
    );

    blocTest<SellerProductsCubit, SellerProductsState>(
      'emits [loading, fail] when repo throws an exception',
      build: () {
        when(
          () => mockPrefs.getSecureData(any()),
        ).thenAnswer((_) async => 'fake-token-123');
        when(
          () => mockRepo.updateProduct(
            token: any(named: 'token'),
            productId: any(named: 'productId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            stock: any(named: 'stock'),
            category: any(named: 'category'),
            type: any(named: 'type'),
            gender: any(named: 'gender'),
            season: any(named: 'season'),
            occasion: any(named: 'occasion'),
            color: any(named: 'color'),
            imagePath: any(named: 'imagePath'),
          ),
        ).thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (cubit) => callUpdateProduct(cubit),
      expect: () => [
        const SellerProductsState.loading(),
        isA<SellerProductsState<dynamic>>().having(
          (s) => s,
          'is fail',
          isA<Fail>(),
        ),
      ],
    );
  });
}
