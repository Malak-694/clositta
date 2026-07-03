import 'package:bloc/bloc.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/customer/closet/data/repo/closet_repo.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_state.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../data/models/closet_item_response_model.dart';

class ClosetCubit extends Cubit<ClosetState> {
  final ClosetRepo closetRepo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  List<ClosetItemResponseModel> allItems = [];
  String selectedCategory = 'All';
  String selectedSeason = 'All';
  String selectedOccasion = 'All';

  ClosetCubit({required this.closetRepo}) : super(ClosetState.initial());

  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  Future<void> viewClosetItems({
    String? category,
    String? season,
    bool showLoading = true, // ✅ NEW: lets us refresh silently
  }) async {
    if (showLoading) emit(ClosetState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const ClosetState.fail("Authentication token not found"));
        return;
      }

      final response = await closetRepo.viewClosetItems(
        token: token,
        category: category != 'All' ? category : null,
        season: season,
      );
      response.when(
        success: (List<ClosetItemResponseModel> data) {
          allItems = data;
          selectedCategory = category ?? 'All';
          _applyFilters();
        },
        failure: (String error) {
          emit(ClosetState.fail("please try again later"));
        },
      );
    } catch (e) {
      emit(
        ClosetState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to load your Closet. Please try again.",
        ),
      );
    }
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    _applyFilters();
  }

  void filterBySeason(String season) {
    selectedSeason = season;
    _applyFilters();
  }

  void filterByOccasion(String occasion) {
    selectedOccasion = occasion;
    _applyFilters();
  }

  void _applyFilters() {
    // ✅ CHANGED: always build a brand-new list, never reuse `allItems` reference directly
    List<ClosetItemResponseModel> filtered = List<ClosetItemResponseModel>.from(allItems);

    if (selectedCategory != 'All') {
      filtered = filtered
          .where((item) => item.category == selectedCategory.toLowerCase())
          .toList();
    }
    if (selectedSeason != 'All') {
      filtered = filtered
          .where((item) => item.season == selectedSeason.toLowerCase())
          .toList();
    }
    if (selectedOccasion != 'All') {
      filtered = filtered
          .where((item) => item.occasion == selectedOccasion.toLowerCase())
          .toList();
    }

    emit(ClosetState.success(filtered));
  }

  Future<void> addClosetItem({
    required String name,
    required String category,
    required String season,
    required String color,
    required String occassion,
    required String imagePath,
  }) async {
    emit(ClosetState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const ClosetState.fail("Authentication token not found"));
        return;
      }

      if (imagePath.isEmpty) {
        emit(const ClosetState.fail("Please select an image"));
        return;
      }

      final response = await closetRepo.addClosetItem(
        token: token,
        name: name,
        category: category,
        season: season,
        color: color,
        occassion: occassion,
        imagePath: imagePath,
      );

      response.when(
        success: (MessageModel data) {
          viewClosetItems();
        },
        failure: (String error) {
          emit(ClosetState.fail(error));
        },
      );
    } catch (e) {
      emit(
        ClosetState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to add item. Please try again.",
        ),
      );
    }
  }

  Future<void> deleteClosetItem({required String itemId}) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const ClosetState.fail("Authentication token not found"));
        return;
      }

      final response = await closetRepo.deleteClosetItem(
        token: token,
        itemId: itemId,
      );
      response.when(
        success: (MessageModel data) {
          // ✅ CHANGED: refetch from server instead of mutating allItems locally
          viewClosetItems(showLoading: false); // silent refresh, no spinner flash
        },
        failure: (String error) {
          emit(ClosetState.fail("Failed to delete item. Please try again."));
        },
      );
    } catch (e) {
      emit(
        ClosetState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to delete item. Please try again.",
        ),
      );
    }
  }

  Future<void> updateClosetItem({
    required String itemId,
    required String name,
    required String category,
    required String season,
    required String color,
    required String occassion,
    String? imagePath,
  }) async {
    emit(ClosetState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const ClosetState.fail("Authentication token not found"));
        return;
      }

      final response = await closetRepo.updateClosetItem(
        token: token,
        itemId: itemId,
        name: name,
        category: category.toLowerCase(),
        season: season.toLowerCase(),
        color: color,
        imagePath: imagePath,
        occassion: occassion.toLowerCase(),
      );

      response.when(
        success: (_) => viewClosetItems(),
        failure: (error) => emit(ClosetState.fail(error)),
      );
    } catch (e) {
      emit(
        ClosetState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to update item. Please try again.",
        ),
      );
    }
  }
}