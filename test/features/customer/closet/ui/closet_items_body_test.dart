// test/features/customer/closet/ui/closet_items_body_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/customer/closet/data/models/closet_item_response_model.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_cubit.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_state.dart';
import 'package:chicora/features/customer/closet/ui/widgets/closet_items_body.dart';
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

final fakeItem2 = ClosetItemResponseModel(
  id: 'item-2',
  name: 'Blue Jeans',
  category: 'Bottoms',
  season: 'All Season',
  color: 'Blue',
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

Widget buildBody(MockClosetCubit cubit) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, _) => MaterialApp(
      home: Scaffold(
        body: BlocProvider<ClosetCubit>.value(
          value: cubit,
          child: const ClosetItemsScreenBody(),
        ),
      ),
      routes: {
        'upload_closet_item': (_) =>
        const Scaffold(body: Text('Add Item Page')),
        'update_closet_item': (_) =>
        const Scaffold(body: Text('Update Item Page')),
      },
    ),
  );
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
    // viewClosetItems is called in initState — stub it to do nothing
    when(() => mockCubit.viewClosetItems(category: any(named: 'category')))
        .thenAnswer((_) async {});
    when(() => mockCubit.state).thenReturn(ClosetState.initial());
  });

  tearDown(() => getIt.reset());

  // ── Initial / loading / error states ────────────────────────────────────

  group('State rendering', () {
    testWidgets('shows loading spinner when state is loading', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      when(() => mockCubit.state).thenReturn(ClosetState.loading());

      await tester.pumpWidget(buildBody(mockCubit));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows "No closet items found" when success with empty list',
            (tester) async {
          setPhoneSize(tester);
          ignoreOverflowErrors(tester);

          when(() => mockCubit.state)
              .thenReturn(ClosetState.success([]));

          await tester.pumpWidget(buildBody(mockCubit));
          await tester.pump();

          expect(find.text('No closet items found'), findsOneWidget);
        });

    testWidgets('shows item names when success with items', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      when(() => mockCubit.state)
          .thenReturn(ClosetState.success([fakeItem, fakeItem2]));

      await tester.pumpWidget(buildBody(mockCubit));
      await tester.pumpAndSettle();

      expect(find.text('White T-Shirt'), findsOneWidget);
      expect(find.text('Blue Jeans'), findsOneWidget);
    });

    testWidgets('shows error text when state is fail', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      when(() => mockCubit.state)
          .thenReturn(const ClosetState.fail('Network error'));

      await tester.pumpWidget(buildBody(mockCubit));
      await tester.pump();

      expect(find.text('Error: please try again later'), findsOneWidget);
    });
  });

  // ── Delete dialog ────────────────────────────────────────────────────────

  group('Delete confirmation dialog', () {
    Future<void> pumpWithItem(WidgetTester tester) async {
      when(() => mockCubit.state)
          .thenReturn(ClosetState.success([fakeItem]));

      await tester.pumpWidget(buildBody(mockCubit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    Future<Finder> findDeleteTrigger(WidgetTester tester) async {
      if (find.byIcon(Icons.delete).evaluate().isNotEmpty) {
        return find.byIcon(Icons.delete);
      }
      if (find.byIcon(Icons.delete_outline).evaluate().isNotEmpty) {
        return find.byIcon(Icons.delete_outline);
      }
      if (find.byTooltip('Delete').evaluate().isNotEmpty) {
        return find.byTooltip('Delete');
      }

      final deleteTexts = find.text('Delete');
      if (deleteTexts.evaluate().isNotEmpty) {
        return deleteTexts.first;
      }
      debugDumpApp();
      throw TestFailure(
        'Could not find any delete trigger widget. '
            'Check the debugDumpApp output above to see what is rendered.',
      );
    }

    testWidgets('tapping delete shows confirmation dialog', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      await pumpWithItem(tester);
      expect(find.text('White T-Shirt'), findsOneWidget);

      final trigger = await findDeleteTrigger(tester);
      await tester.tapAt(tester.getCenter(trigger));
      await tester.pump();

      expect(
        find.text('Are you sure you want to delete White T-Shirt?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('tapping Cancel closes dialog without calling cubit',
            (tester) async {
          setPhoneSize(tester);
          ignoreOverflowErrors(tester);

          await pumpWithItem(tester);

          final trigger = await findDeleteTrigger(tester);
          await tester.tapAt(tester.getCenter(trigger));
          await tester.pump();

          await tester.tap(find.text('Cancel'));
          await tester.pumpAndSettle();

          expect(
            find.text('Are you sure you want to delete White T-Shirt?'),
            findsNothing,
          );
          verifyNever(
                  () => mockCubit.deleteClosetItem(itemId: any(named: 'itemId')));
        });

    testWidgets('tapping Delete calls cubit.deleteClosetItem', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      when(() => mockCubit.deleteClosetItem(itemId: any(named: 'itemId')))
          .thenAnswer((_) async {});

      await pumpWithItem(tester);

      final trigger = await findDeleteTrigger(tester);
      await tester.tapAt(tester.getCenter(trigger));
      await tester.pump();

      // The dialog's Delete button — use last to avoid matching card buttons
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();

      verify(() => mockCubit.deleteClosetItem(itemId: 'item-1')).called(1);

      expect(
        find.text('Are you sure you want to delete White T-Shirt?'),
        findsNothing,
      );
    });
  });
  // ── Filter dropdowns ─────────────────────────────────────────────────────

  group('Filter dropdowns', () {
    testWidgets('tapping category dropdown calls filterByCategory',
            (tester) async {
          setPhoneSize(tester);
          ignoreOverflowErrors(tester);

          when(() => mockCubit.state)
              .thenReturn(ClosetState.success([fakeItem, fakeItem2]));
          when(() => mockCubit.filterByCategory(any()))
              .thenAnswer((_) {});

          await tester.pumpWidget(buildBody(mockCubit));
          await tester.pumpAndSettle();

          await tester.tap(find.text('All').first);
          await tester.pumpAndSettle();

          await tester.tap(find.text('Tops').last);
          await tester.pumpAndSettle();

          verify(() => mockCubit.filterByCategory('Tops')).called(1);
        });

    testWidgets('tapping season dropdown calls filterBySeason', (tester) async {
      setPhoneSize(tester);
      ignoreOverflowErrors(tester);

      when(() => mockCubit.state)
          .thenReturn(ClosetState.success([fakeItem, fakeItem2]));
      when(() => mockCubit.filterBySeason(any()))
          .thenAnswer((_) {});

      await tester.pumpWidget(buildBody(mockCubit));
      await tester.pumpAndSettle();

      // Open the season dropdown (second 'All')
      await tester.tap(find.text('All').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Winter').last);
      await tester.pumpAndSettle();

      verify(() => mockCubit.filterBySeason('Winter')).called(1);
    });
  });
}