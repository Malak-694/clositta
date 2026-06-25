import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/data/repo/seller_product_repo.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';



class MockSellerProductRepo extends Mock implements SellerProductRepo {}
class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

void main(){
  late MockSellerProductRepo mockRepo ;
  late MockSharedPrefHelper mockPrefs ;
  late SellerProductsCubit cubit ;

// top of file, outside main()
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

  setUp((){
    mockRepo = MockSellerProductRepo();
    mockPrefs = MockSharedPrefHelper();
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    cubit = SellerProductsCubit(sellerProductRepo: mockRepo);
  });
  tearDown((){
    cubit.close();
    getIt.reset();
  });

  group('getProducts', (){
    blocTest<SellerProductsCubit , SellerProductsState>( 'emits [loading, success] when token exists and API returns products',
    build: (){
      when(()=> mockPrefs.getSecureData(any())).
           thenAnswer((_) async => 'fake-token-123');
      when(()=> mockRepo.getProductsSeller(any())).
           thenAnswer((_) async => [fakeProduct]);

      return cubit ;
    },
      act: (cubit) => cubit.getProducts(),

      expect: () => [
        const SellerProductsState.loading(),
        isA<Success<dynamic>>().having(
              (s) => (s.data as List).first,
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
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => null);
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
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');

        when(() => mockRepo.getProductsSeller(any()))
            .thenThrow(Exception('Network error'));
        return cubit;
      },

      act: (cubit) => cubit.getProducts(),

      expect: () => [
        const SellerProductsState.loading(),
        isA<SellerProductsState<dynamic>>()
            .having((s) => s, 'is fail', isA<Fail>()),
      ],
    );
  } );


  group('deleteProduct()', () {

    blocTest<SellerProductsCubit, SellerProductsState>(
      'calls repo.deleteProduct then reloads the product list',

      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');

        when(() => mockRepo.deleteProduct(any(), any()))
            .thenAnswer((_) async => MessageModel(message: 'deleted'));

        when(() => mockRepo.getProductsSeller(any()))
            .thenAnswer((_) async => []);

        return cubit;
      },

      act: (cubit) => cubit.deleteProduct('p1'),
      expect: () => [
        const SellerProductsState.loading(),
        isA<Success<dynamic>>().having(
              (s) => s.data,
          'empty list',
          isEmpty,
        ),
      ],

      verify: (_) {
        verify(() => mockRepo.deleteProduct('fake-token-123', 'p1'))
            .called(1);
      },
    );
  });
}