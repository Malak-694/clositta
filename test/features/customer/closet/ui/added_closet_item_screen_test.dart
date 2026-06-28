// test/features/customer/closet/ui/added_closet_item_screen_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/customer/closet/data/models/closet_item_response_model.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_cubit.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_state.dart';
import 'package:chicora/features/customer/closet/ui/screens/added_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClosetCubit extends MockCubit<ClosetState>
    implements ClosetCubit {}

class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

final fakeItem = ClosetItemResponseModel(
  id: 'item-1',
  name: 'White T-Shirt',
  category: 'Tops',
  season: 'Summer',
  color: 'White',
  imageUrl: 'https://via.placeholder.com/100',
);

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

Widget buildScreen({
  required MockClosetCubit cubit,
  ClosetItemResponseModel? item,
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, _) => MaterialApp(
      home: BlocProvider<ClosetCubit>.value(
        value: cubit,
        child: AddedClosetItemScreen(item: item),
      ),
    ),
  );
}

Future<void> scrollAndTapButton(WidgetTester tester, String label) async {
  await tester.drag(
      find.byType(SingleChildScrollView), const Offset(0, -600));
  await tester.pumpAndSettle();
  final btn = find.ancestor(
    of: find.text(label),
    matching: find.byType(ElevatedButton),
  );
  await tester.tap(btn.first);
  await tester.pump();
}

void main() {
  late MockClosetCubit mockCubit;
  late MockSharedPrefHelper mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPrefHelper();
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    when(() => mockPrefs.getSecureData(any()))
        .thenAnswer((_) async => null);

    mockCubit = MockClosetCubit();
    when(() => mockCubit.state).thenReturn(ClosetState.initial());
  });

  tearDown(() => getIt.reset());


  group('Add mode (item == null)', () {
    testWidgets('renders "Add New Item" title and "Add Item" button',
            (tester) async {
          setPhoneSize(tester);
          ignoreOverflowErrors(tester);

          await tester.pumpWidget(buildScreen(cubit: mockCubit));
          await tester.pump();

          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text('Add New Item'),
            ),
            findsOneWidget,
          );

          await tester.drag(
              find.byType(SingleChildScrollView), const Offset(0, -600));
          await tester.pumpAndSettle();

          expect(
            find.ancestor(
              of: find.text('Add Item'),
              matching: find.byType(ElevatedButton),
            ),
            findsOneWidget,
          );
        });

    testWidgets('shows snackbar when name is empty', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(buildScreen(cubit: mockCubit));
      await scrollAndTapButton(tester, 'Add Item');

      expect(find.text('Please enter a name'), findsOneWidget);
    });

    testWidgets('shows snackbar when color is empty', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(buildScreen(cubit: mockCubit));

      await tester.enterText(
          find.widgetWithText(TextField, 'e.g., Wedding Dress'), 'My Shirt');

      await scrollAndTapButton(tester, 'Add Item');

      expect(find.text('Please enter a color'), findsOneWidget);
    });

    testWidgets('shows snackbar when no image selected', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(buildScreen(cubit: mockCubit));

      await tester.enterText(
          find.widgetWithText(TextField, 'e.g., Wedding Dress'), 'My Shirt');
      await tester.enterText(
          find.widgetWithText(TextField, 'e.g., white'), 'White');

      await scrollAndTapButton(tester, 'Add Item');

      expect(find.text('Please select an image'), findsOneWidget);
    });

    testWidgets('does not call addClosetItem without an image', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await tester.pumpWidget(buildScreen(cubit: mockCubit));

      await tester.enterText(
          find.widgetWithText(TextField, 'e.g., Wedding Dress'), 'My Shirt');
      await tester.enterText(
          find.widgetWithText(TextField, 'e.g., white'), 'White');

      await scrollAndTapButton(tester, 'Add Item');

      verifyNever(() => mockCubit.addClosetItem(
        name: any(named: 'name'),
        category: any(named: 'category'),
        season: any(named: 'season'),
        color: any(named: 'color'),
        imagePath: any(named: 'imagePath'),
      ));
    });
  });


  group('Update mode (item != null)', () {
    testWidgets('renders "Update Item" title and pre-fills all fields',
            (tester) async {
          setPhoneSize(tester);
          ignoreOverflowErrors(tester);

          await tester.pumpWidget(buildScreen(cubit: mockCubit, item: fakeItem));
          await tester.pump();

          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text('Update Item'),
            ),
            findsOneWidget,
          );
          expect(find.text('White T-Shirt'), findsOneWidget);
          expect(find.text('White'), findsOneWidget);
        });

    testWidgets('calls cubit.updateClosetItem when form is valid',
            (tester) async {
          setPhoneSize(tester);
          ignoreOverflowErrors(tester);

          when(() => mockCubit.updateClosetItem(
            itemId: any(named: 'itemId'),
            name: any(named: 'name'),
            category: any(named: 'category'),
            season: any(named: 'season'),
            color: any(named: 'color'),
            imagePath: any(named: 'imagePath'),
          )).thenAnswer((_) async {});

          await tester.pumpWidget(buildScreen(cubit: mockCubit, item: fakeItem));
          await scrollAndTapButton(tester, 'Update Item');

          verify(() => mockCubit.updateClosetItem(
            itemId: 'item-1',
            name: 'White T-Shirt',
            category: 'Tops',
            season: 'Summer',
            color: 'White',
            imagePath: null,
          )).called(1);
        });

    testWidgets('shows snackbar when name is cleared before updating',
            (tester) async {
          setPhoneSize(tester);
          ignoreOverflowErrors(tester);

          await tester.pumpWidget(buildScreen(cubit: mockCubit, item: fakeItem));

          await tester.enterText(
              find.widgetWithText(TextField, 'White T-Shirt'), '');

          await scrollAndTapButton(tester, 'Update Item');

          expect(find.text('Please enter a name'), findsOneWidget);
        });
  });


  group('State reactions', () {
    testWidgets('shows CircularProgressIndicator when loading', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      when(() => mockCubit.state).thenReturn(ClosetState.loading());

      await tester.pumpWidget(buildScreen(cubit: mockCubit));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('pops screen on success', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      whenListen(
        mockCubit,
        Stream.fromIterable([
          ClosetState.loading(),
          ClosetState.success(null),
        ]),
        initialState: ClosetState.initial(),
      );

      await tester.pumpWidget(buildScreen(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(find.byType(AddedClosetItemScreen), findsNothing);
    });

    testWidgets('shows snackbar on fail state', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      whenListen(
        mockCubit,
        Stream.fromIterable([
          const ClosetState.fail('Upload failed'),
        ]),
        initialState: ClosetState.initial(),
      );

      await tester.pumpWidget(buildScreen(cubit: mockCubit));
      await tester.pump();

      expect(find.text('Upload failed'), findsOneWidget);
    });
  });
}