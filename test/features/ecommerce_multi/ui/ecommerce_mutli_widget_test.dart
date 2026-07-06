import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_page_ui_model.dart';
import 'package:chicora/features/ecommerce_multi/data/models/product_models/product_response_model.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_state.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/buyer_product_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockViewProductsCubit
    extends MockCubit<ViewProductsState<ProductPageData>>
    implements ViewProductsCubit {}

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
    final message = details.exceptionAsString();
    if (message.contains('overflowed') ||
        message.contains('NetworkImageLoadException') ||
        message.contains('image codec')) {
      return;
    }
    originalOnError?.call(details);
  };
  addTearDown(() => FlutterError.onError = originalOnError);
}

void main() {
  late MockViewProductsCubit cubit;
  late MockSharedPrefHelper mockPrefs;
  final fakeProduct = ProductModelBuyer(
    pId: 'product-1',
    name: 'Blue Cotton Dress',
    description: 'Soft and stylish dress',
    price: 120,
    stock: 15,
    category: 'Dress',
    type: 'Clothes',
    imageUrl: null,
    imageFileId: 'file-1',
    averageRating: 4.5,
    totalRatings: 10,
    ratings: [],
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-02T00:00:00Z',
    iV: 0,
  );

  // success() now wraps a ProductPageData, not a bare List<ProductModelBuyer>.
  final fakePageData = ProductPageData(
    products: [fakeProduct],
    hasMore: false,
    isLoadingMore: false,
  );

  setUp(() {
    mockPrefs = MockSharedPrefHelper();
    if (!getIt.isRegistered<SharedPrefHelper>()) {
      getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    }
    cubit = MockViewProductsCubit();

    when(
      () => mockPrefs.getSecureData(any()),
    ).thenAnswer((_) async => 'token-123');
    when(
      () => cubit.getProductsBuyer(
        token: any(named: 'token'),
        type: any(named: 'type'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => cubit.searchByText(query: any(named: 'query')),
    ).thenAnswer((_) async {});
  });

  tearDown(() => getIt.reset());

  Widget buildScreen() {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, _) => MaterialApp(
        home: Scaffold(
          body: BlocProvider<ViewProductsCubit>.value(
            value: cubit,
            child: const BuyerProductScreenBody(),
          ),
        ),
      ),
    );
  }

  testWidgets('shows loading spinner when state is loading', (tester) async {
    setPhoneSize(tester);
    ignoreOverflowErrors(tester);

    when(
      () => cubit.state,
    ).thenReturn(const ViewProductsState<ProductPageData>.loading());

    await tester.pumpWidget(buildScreen());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows products when state is a success', (tester) async {
    setPhoneSize(tester);
    ignoreOverflowErrors(tester);

    when(
      () => cubit.state,
    ).thenReturn(ViewProductsState<ProductPageData>.success(fakePageData));
    whenListen(
      cubit,
      Stream.fromIterable([
        ViewProductsState<ProductPageData>.success(fakePageData),
      ]),
      initialState: ViewProductsState<ProductPageData>.success(fakePageData),
    );

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Blue Cotton Dress'), findsOneWidget);
  });

  testWidgets('shows error message when state is fail', (tester) async {
    setPhoneSize(tester);
    ignoreOverflowErrors(tester);

    when(() => cubit.state).thenReturn(
      const ViewProductsState<ProductPageData>.fail('Network error'),
    );

    await tester.pumpWidget(buildScreen());
    await tester.pump();

    expect(
      find.text('There is a connection error, please try again later'),
      findsOneWidget,
    );
  });

  testWidgets('search input triggers cubit search', (tester) async {
    setPhoneSize(tester);
    ignoreOverflowErrors(tester);

    when(
      () => cubit.state,
    ).thenReturn(ViewProductsState<ProductPageData>.success(fakePageData));
    whenListen(
      cubit,
      Stream.fromIterable([
        ViewProductsState<ProductPageData>.success(fakePageData),
      ]),
      initialState: ViewProductsState<ProductPageData>.success(fakePageData),
    );

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'dress');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    verify(() => cubit.searchByText(query: 'dress')).called(1);
  });
}
