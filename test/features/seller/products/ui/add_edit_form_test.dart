import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/seller/products/data/models/product_model_response.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_state.dart';
import 'package:chicora/features/seller/products/ui/screens/added_product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

Future<void> scrollAndTapButton(WidgetTester tester, String label) async {
  await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -600));
  await tester.pumpAndSettle();

  final btn = find.ancestor(
    of: find.text(label),
    matching: find.byType(ElevatedButton),
  );
  await tester.tap(btn.first);
  await tester.pump();
}

Widget buildTestWidget({
  required MockSellerProductsCubit cubit,
  ProductModel? product,
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, _) => MaterialApp(
      home: BlocProvider<SellerProductsCubit>.value(
        value: cubit,
        child: AddedProductForm(product: product),
      ),
    ),
  );
}

final fakeProduct = ProductModel(
  ratingDistribution: {'1': 0, '2': 0, '3': 1, '4': 2, '5': 5},
  id: 'test-product-id-1',
  seller: 'test-seller-id-1',
  name: 'Blue Cotton Fabric',
  description: 'High quality cotton fabric',
  price: 12.99,
  stock: 500,
  category: 'Tops',
  type: 'Clothes',
  imageUrl: 'https://via.placeholder.com/100',
  imageFileId: 'file-id-1',
  averageRating: 4.5,
  totalRatings: 8,
  ratings: [],
  createdAt: DateTime(2024, 1, 1),
  updatedAt: DateTime(2024, 1, 2),
  v: 0,
);

void main() {
  late MockSellerProductsCubit mockCubit;
  late MockSharedPrefHelper mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPrefHelper();
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    when(() => mockPrefs.getSecureData(any())).thenAnswer((_) async => null);

    mockCubit = MockSellerProductsCubit();
    when(() => mockCubit.state).thenReturn(const SellerProductsState.initial());
  });

  tearDown(() => getIt.reset());

  group('Add mode (product == null)', () {
    testWidgets('renders "Add New Product" title and "Add Product" button', (
      tester,
    ) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(buildTestWidget(cubit: mockCubit));
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Add New Product'),
        ),
        findsOneWidget,
      );

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();

      expect(
        find.ancestor(
          of: find.text('Add Product'),
          matching: find.byType(ElevatedButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows snackbar when submitting with empty fields', (
      tester,
    ) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(buildTestWidget(cubit: mockCubit));

      await scrollAndTapButton(tester, 'Add Product');

      expect(find.text('Please enter all fields'), findsOneWidget);
    });

    testWidgets('shows snackbar when all fields filled but no image selected', (
      tester,
    ) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(buildTestWidget(cubit: mockCubit));

      await tester.enterText(
        find.widgetWithText(TextField, 'e.g., Wedding Dress'),
        'My Fabric',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Describe your product...'),
        'Nice',
      );
      await tester.enterText(find.widgetWithText(TextField, '00.0'), '25.00');
      await tester.enterText(find.widgetWithText(TextField, '0'), '50');

      await scrollAndTapButton(tester, 'Add Product');

      expect(find.text('Please select an image'), findsOneWidget);
    });

    testWidgets('does not call addProduct without an image', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(buildTestWidget(cubit: mockCubit));

      await tester.enterText(
        find.widgetWithText(TextField, 'e.g., Wedding Dress'),
        'My Fabric',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Describe your product...'),
        'Nice',
      );
      await tester.enterText(find.widgetWithText(TextField, '00.0'), '10.00');
      await tester.enterText(find.widgetWithText(TextField, '0'), '20');

      await scrollAndTapButton(tester, 'Add Product');

      verifyNever(
        () => mockCubit.addProduct(
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
      );
    });
  });

  group('Update mode (product != null)', () {
    testWidgets('renders "Update Product" title and pre-fills all fields', (
      tester,
    ) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(
        buildTestWidget(cubit: mockCubit, product: fakeProduct),
      );
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Update Product'),
        ),
        findsOneWidget,
      );
      expect(find.text('Add New Product'), findsNothing);
      expect(find.text('Blue Cotton Fabric'), findsOneWidget);
      expect(find.text('High quality cotton fabric'), findsOneWidget);
      expect(find.text('12.99'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
    });

    testWidgets('calls cubit.updateProduct when form is valid and submitted', (
      tester,
    ) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      when(
        () => mockCubit.updateProduct(
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
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        buildTestWidget(cubit: mockCubit, product: fakeProduct),
      );

      await scrollAndTapButton(tester, 'Update Product');

      verify(
        () => mockCubit.updateProduct(
          productId: 'test-product-id-1',
          name: 'Blue Cotton Fabric',
          description: 'High quality cotton fabric',
          price: '12.99',
          stock: '500',
          category: 'Tops',
          type: 'Clothes',
          gender: 'Unisex',
          season: 'All',
          occasion: 'Casual',
          color: 'Red',
          imagePath: null,
        ),
      ).called(1);
    });

    testWidgets('shows snackbar when updating with an empty required field', (
      tester,
    ) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(
        buildTestWidget(cubit: mockCubit, product: fakeProduct),
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Blue Cotton Fabric'),
        '',
      );

      await scrollAndTapButton(tester, 'Update Product');

      expect(find.text('Please enter all fields'), findsOneWidget);
    });
  });

  group('State reactions', () {
    testWidgets('shows CircularProgressIndicator when state is loading', (
      tester,
    ) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      when(
        () => mockCubit.state,
      ).thenReturn(const SellerProductsState.loading());

      await tester.pumpWidget(buildTestWidget(cubit: mockCubit));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('pops the screen on success state', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      whenListen(
        mockCubit,
        Stream.fromIterable([
          const SellerProductsState.loading(),
          const SellerProductsState.success(null),
        ]),
        initialState: const SellerProductsState.initial(),
      );

      await tester.pumpWidget(buildTestWidget(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(find.byType(AddedProductForm), findsNothing);
    });

    testWidgets('shows snackbar with error message on fail state', (
      tester,
    ) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      whenListen(
        mockCubit,
        Stream.fromIterable([
          const SellerProductsState.fail('Something went wrong'),
        ]),
        initialState: const SellerProductsState.initial(),
      );

      await tester.pumpWidget(buildTestWidget(cubit: mockCubit));
      await tester.pump();

      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });
}
