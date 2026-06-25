import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_state.dart';
import 'package:chicora/features/seller/products/ui/widgets/product_card_widget.dart';
import 'package:chicora/features/seller/products/ui/widgets/seller_product_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockSellerProductsCubit extends MockCubit<SellerProductsState>
    implements SellerProductsCubit {}

class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

void setPhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void ignoreOverflowErrors(WidgetTester tester) {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    originalOnError?.call(details);
  };
  addTearDown(() => FlutterError.onError = originalOnError);
}

void main() {
  late MockSellerProductsCubit cubit;
  late MockSharedPrefHelper mockPrefs;

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

  setUp(() {
    mockPrefs = MockSharedPrefHelper();
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    cubit = MockSellerProductsCubit();
  });

  tearDown(() {
    getIt.reset();
  });

  Widget buildScreen() {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, __) => MaterialApp(
        home: Scaffold(
          body: BlocProvider<SellerProductsCubit>.value(
            value: cubit,
            child: const SellerProductScreenBody(),
          ),
        ),
        routes: {
          'added_product_item': (_) =>
          const Scaffold(body: Text('Add Product Page')),
          'update_product_screen': (_) =>
          const Scaffold(body: Text('Update Product Page')),
        },
      ),
    );
  }

  Widget buildCardOnly(ProductModel product) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, __) => MaterialApp(
        home: Scaffold(
          body: BlocProvider<SellerProductsCubit>.value(
            value: cubit,
            // Builder gives us a real BuildContext for buildProductCard
            child: Builder(
              builder: (context) => buildProductCard(context, product),
            ),
          ),
        ),
        routes: {
          'update_product_screen': (_) =>
          const Scaffold(body: Text('Update Product Page')),
        },
      ),
    );
  }


  testWidgets('shows loading spinner when state is loading', (tester) async {
    setPhoneSize(tester);
    ignoreOverflowErrors(tester);

    when(() => cubit.state)
        .thenReturn(const SellerProductsState.loading());

    await tester.pumpWidget(buildScreen());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('0 Products'), findsOneWidget);
  });


  testWidgets('shows product cards when state is success', (tester) async {
    setPhoneSize(tester);
    ignoreOverflowErrors(tester);

    when(() => cubit.state).thenReturn(
      SellerProductsState.success([fakeProduct]),
    );
    whenListen(
      cubit,
      Stream.fromIterable([
        const SellerProductsState.loading(),
        SellerProductsState.success([fakeProduct]),
      ]),
      initialState: SellerProductsState.success([fakeProduct]),
    );

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Blue Cotton Fabric'), findsOneWidget);
    expect(find.text('1 Products'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });


  testWidgets('shows error message when state is fail', (tester) async {
    setPhoneSize(tester);
    ignoreOverflowErrors(tester);

    when(() => cubit.state).thenReturn(
      const SellerProductsState.fail('Network error'),
    );

    await tester.pumpWidget(buildScreen());
    await tester.pump();

    expect(find.text('Error: Network error'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  //
  // testWidgets('tapping delete icon shows confirmation dialog', (tester) async {
  //   setPhoneSize(tester);
  //   ignoreOverflowErrors(tester);
  //
  //   when(() => cubit.state).thenReturn(
  //     SellerProductsState.success([fakeProduct]),
  //   );
  //
  //   await tester.pumpWidget(buildCardOnly(fakeProduct));
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byIcon(Icons.delete), findsOneWidget);
  //
  //   await tester.tap(find.byIcon(Icons.delete));
  //   await tester.pump();
  //
  //   expect(
  //     find.text('Are you sure you want to Delete this product?'),
  //     findsOneWidget,
  //   );
  //   expect(find.text('Cancel'), findsOneWidget);
  //   expect(find.text('Delete'), findsOneWidget);
  // });
  //
  // // ── 4b: Cancel closes dialog without calling cubit ───────────────────
  // testWidgets('tapping Cancel closes dialog without deleting', (tester) async {
  //   setPhoneSize(tester);
  //   ignoreOverflowErrors(tester);
  //
  //   when(() => cubit.state).thenReturn(
  //     SellerProductsState.success([fakeProduct]),
  //   );
  //
  //   await tester.pumpWidget(buildCardOnly(fakeProduct));
  //   await tester.pumpAndSettle();
  //
  //   await tester.tap(find.byIcon(Icons.delete));
  //   await tester.pump();
  //
  //   await tester.tap(find.text('Cancel'));
  //   await tester.pumpAndSettle();
  //
  //   expect(
  //     find.text('Are you sure you want to Delete this product?'),
  //     findsNothing,
  //   );
  //   verifyNever(() => cubit.deleteProduct(any()));
  // });
  //
  // // ── 4c: Delete button calls cubit with correct id ─────────────────────
  // testWidgets('tapping Delete calls cubit.deleteProduct', (tester) async {
  //   setPhoneSize(tester);
  //   ignoreOverflowErrors(tester);
  //
  //   when(() => cubit.state).thenReturn(
  //     SellerProductsState.success([fakeProduct]),
  //   );
  //   when(() => cubit.deleteProduct(any())).thenAnswer((_) async {});
  //
  //   await tester.pumpWidget(buildCardOnly(fakeProduct));
  //   await tester.pumpAndSettle();
  //
  //   await tester.tap(find.byIcon(Icons.delete));
  //   await tester.pump();
  //
  //   // .last targets the dialog's Delete button specifically
  //   await tester.tap(find.text('Delete').last);
  //   await tester.pumpAndSettle();
  //
  //   verify(() => cubit.deleteProduct('test-product-id-1')).called(1);
  //
  //   expect(
  //     find.text('Are you sure you want to Delete this product?'),
  //     findsNothing,
  //   );
  // });

  // ════════════════════════════════════════════════════════════════════════
  // TEST 5 — Search / filter
  // ════════════════════════════════════════════════════════════════════════
  testWidgets('typing in search bar filters products by name', (tester) async {
    setPhoneSize(tester);
    ignoreOverflowErrors(tester);

    final secondProduct = ProductModel(
      ratingDistribution: {},
      id: 'p2',
      seller: 's1',
      name: 'Red Silk',
      description: 'desc',
      price: 9.99,
      stock: 100,
      category: 'Fabric',
      type: 'Silk',
      imageUrl: 'https://via.placeholder.com/100',
      imageFileId: 'f2',
      averageRating: 3.0,
      totalRatings: 2,
      ratings: [],
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
      v: 0,
    );

    when(() => cubit.state).thenReturn(
      SellerProductsState.success([fakeProduct, secondProduct]),
    );
    whenListen(
      cubit,
      Stream.fromIterable([
        SellerProductsState.success([fakeProduct, secondProduct]),
      ]),
      initialState: SellerProductsState.success([fakeProduct, secondProduct]),
    );

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Blue Cotton Fabric'), findsOneWidget);
    expect(find.text('Red Silk'), findsOneWidget);
    expect(find.text('2 Products'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'blue');
    await tester.pump();

    expect(find.text('Blue Cotton Fabric'), findsOneWidget);
    expect(find.text('Red Silk'), findsNothing);
    expect(find.text('1 Products'), findsOneWidget);
  });
}