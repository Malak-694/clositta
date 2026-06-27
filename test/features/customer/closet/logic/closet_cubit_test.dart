// test/features/customer/closet/cubit/closet_cubit_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/customer/closet/data/models/closet_item_response_model.dart';
import 'package:chicora/features/customer/closet/data/repo/closet_repo.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_cubit.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClosetRepo extends Mock implements ClosetRepo {}
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

void main() {
  late MockClosetRepo mockRepo;
  late MockSharedPrefHelper mockPrefs;
  late ClosetCubit cubit;

  setUp(() {
    mockRepo = MockClosetRepo();
    mockPrefs = MockSharedPrefHelper();
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    cubit = ClosetCubit(closetRepo: mockRepo);
  });

  tearDown(() {
    cubit.close();
    getIt.reset();
  });


  group('viewClosetItems()', () {
    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, success] when token exists and API returns items',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token');
        when(() => mockRepo.viewClosetItems(
          token: any(named: 'token'),
          category: any(named: 'category'),
          season: any(named: 'season'),
        )).thenAnswer(
                (_) async => ApiResult.success([fakeItem, fakeItem2]));
        return cubit;
      },
      act: (c) => c.viewClosetItems(),
      expect: () => [
        ClosetState.loading(),
        isA<ClosetState>().having(
              (s) => s.maybeWhen(
            success: (data) => (data as List).length,
            orElse: () => -1,
          ),
          'item count',
          2,
        ),
      ],
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, fail] when token is null',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => null);
        return cubit;
      },
      act: (c) => c.viewClosetItems(),
      expect: () => [
        ClosetState.loading(),
        const ClosetState.fail('Authentication token not found'),
      ],
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, fail] when API returns failure',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token');
        when(() => mockRepo.viewClosetItems(
          token: any(named: 'token'),
          category: any(named: 'category'),
          season: any(named: 'season'),
        )).thenAnswer(
                (_) async => const ApiResult.failure('Server error'));
        return cubit;
      },
      act: (c) => c.viewClosetItems(),
      expect: () => [
        ClosetState.loading(),
        const ClosetState.fail('please try again later'),
      ],
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, fail] when repo throws exception',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token');
        when(() => mockRepo.viewClosetItems(
          token: any(named: 'token'),
          category: any(named: 'category'),
          season: any(named: 'season'),
        )).thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (c) => c.viewClosetItems(),
      expect: () => [
        ClosetState.loading(),
        isA<ClosetState>().having(
              (s) => s.maybeWhen(fail: (e) => e, orElse: () => null),
          'error',
          isNotNull,
        ),
      ],
    );
  });


  group('filterByCategory()', () {
    test('filters allItems by category and emits success with filtered list',
            () {
          cubit.allItems = [fakeItem, fakeItem2];

          cubit.filterByCategory('Tops');

          expect(
            cubit.state.maybeWhen(
              success: (data) => (data as List).length,
              orElse: () => -1,
            ),
            1,
          );
        });

    test('emits all items when category is All', () {
      cubit.allItems = [fakeItem, fakeItem2];

      cubit.filterByCategory('All');

      expect(
        cubit.state.maybeWhen(
          success: (data) => (data as List).length,
          orElse: () => -1,
        ),
        2,
      );
    });
  });


  group('filterBySeason()', () {
    test('filters allItems by season and emits success with filtered list', () {
      cubit.allItems = [fakeItem, fakeItem2];

      cubit.filterBySeason('Summer');

      expect(
        cubit.state.maybeWhen(
          success: (data) => (data as List).length,
          orElse: () => -1,
        ),
        1,
      );
    });
  });


  group('addClosetItem()', () {
    void callAdd(ClosetCubit c) => c.addClosetItem(
      name: 'White T-Shirt',
      category: 'Tops',
      season: 'Summer',
      color: 'White',
      imagePath: '/fake/image.jpg',
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, success] when token exists and API succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token');

        when(() => mockRepo.addClosetItem(
          token: any(named: 'token'),
          name: any(named: 'name'),
          category: any(named: 'category'),
          season: any(named: 'season'),
          color: any(named: 'color'),
          imagePath: any(named: 'imagePath'),
        )).thenAnswer(
                (_) async => ApiResult.success(MessageModel(message: 'added')));

        when(() => mockRepo.viewClosetItems(
          token: any(named: 'token'),
          category: any(named: 'category'),
          season: any(named: 'season'),
        )).thenAnswer((_) async => ApiResult.success([fakeItem]));
        return cubit;
      },

      act: callAdd,

      expect: () => [
        ClosetState.loading(),
        isA<ClosetState>().having(
              (s) => s.maybeWhen(success: (_) => true, orElse: () => false),
          'is success',
          true,
        ),
      ],
      verify: (_) {
        verify(() => mockRepo.addClosetItem(
          token: 'fake-token',
          name: 'White T-Shirt',
          category: 'Tops',
          season: 'Summer',
          color: 'White',
          imagePath: '/fake/image.jpg',
        )).called(1);
      },
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, fail] when token is null',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => null);
        return cubit;
      },
      act: callAdd,
      expect: () => [
        ClosetState.loading(),
        const ClosetState.fail('Authentication token not found'),
      ],
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, fail] when API returns failure',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token');
        when(() => mockRepo.addClosetItem(
          token: any(named: 'token'),
          name: any(named: 'name'),
          category: any(named: 'category'),
          season: any(named: 'season'),
          color: any(named: 'color'),
          imagePath: any(named: 'imagePath'),
        )).thenAnswer(
                (_) async => const ApiResult.failure('Upload failed'));
        return cubit;
      },
      act: callAdd,
      expect: () => [
        ClosetState.loading(),
        const ClosetState.fail('Upload failed'),
      ],
    );
  });


  group('deleteClosetItem()', () {
    blocTest<ClosetCubit, ClosetState>(
      'removes item from allItems and emits updated success list',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token');

        when(() => mockRepo.deleteClosetItem(
          token: any(named: 'token'),
          itemId: any(named: 'itemId'),
        )).thenAnswer(
                (_) async => ApiResult.success(MessageModel(message: 'ok')));
        return cubit;
      },

      seed: () {
        cubit.allItems = [fakeItem, fakeItem2];
        return ClosetState.success([fakeItem, fakeItem2]);
      },

      act: (c) => c.deleteClosetItem(itemId: 'item-1'),

      expect: () => [
        isA<ClosetState>().having(
              (s) => s.maybeWhen(
            success: (data) => (data as List).length,
            orElse: () => -1,
          ),
          'remaining items',
          1,
        ),
      ],

      verify: (_) {
        verify(() => mockRepo.deleteClosetItem(
          token: 'fake-token',
          itemId: 'item-1',
        )).called(1);
      },
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits fail when token is null',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => null);
        return cubit;
      },
      act: (c) => c.deleteClosetItem(itemId: 'item-1'),
      expect: () => [
        const ClosetState.fail('Authentication token not found'),
      ],
    );
  });


  group('updateClosetItem()', () {
    void callUpdate(ClosetCubit c) => c.updateClosetItem(
      itemId: 'item-1',
      name: 'Updated Shirt',
      category: 'Tops',
      season: 'Winter',
      color: 'Red',
      imagePath: null,
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, success] when token exists and API succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token');
        when(() => mockRepo.updateClosetItem(
          token: any(named: 'token'),
          itemId: any(named: 'itemId'),
          name: any(named: 'name'),
          category: any(named: 'category'),
          season: any(named: 'season'),
          color: any(named: 'color'),
          imagePath: any(named: 'imagePath'),
        )).thenAnswer(
                (_) async => ApiResult.success(MessageModel(message: 'ok')));
        return cubit;
      },
      act: callUpdate,
      expect: () => [
        ClosetState.loading(),
        isA<ClosetState>().having(
              (s) => s.maybeWhen(success: (_) => true, orElse: () => false),
          'is success',
          true,
        ),
      ],
      verify: (_) {
        verify(() => mockRepo.updateClosetItem(
          token: 'fake-token',
          itemId: 'item-1',
          name: 'Updated Shirt',
          category: 'Tops',
          season: 'Winter',
          color: 'Red',
          imagePath: null,
        )).called(1);
      },
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, fail] when token is null',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => null);
        return cubit;
      },
      act: callUpdate,
      expect: () => [
        ClosetState.loading(),
        const ClosetState.fail('Authentication token not found'),
      ],
    );

    blocTest<ClosetCubit, ClosetState>(
      'emits [loading, fail] when API returns failure',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token');
        when(() => mockRepo.updateClosetItem(
          token: any(named: 'token'),
          itemId: any(named: 'itemId'),
          name: any(named: 'name'),
          category: any(named: 'category'),
          season: any(named: 'season'),
          color: any(named: 'color'),
          imagePath: any(named: 'imagePath'),
        )).thenAnswer(
                (_) async => const ApiResult.failure('Update failed'));
        return cubit;
      },
      act: callUpdate,
      expect: () => [
        ClosetState.loading(),
        const ClosetState.fail('Update failed'),
      ],
    );
  });
}