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

  ClosetCubit({required this.closetRepo}) : super(ClosetState.initial());
  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  Future<void> viewClosetItems({String? category, String? season}) async {
    emit(ClosetState.loading());
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
          emit(ClosetState.success(data));
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

  void _applyFilters() {
    List<ClosetItemResponseModel> filtered = allItems;

    // Filter by category
    if (selectedCategory != 'All') {
      filtered = filtered
          .where((item) => item.category == selectedCategory)
          .toList();
    }

    // Filter by season
    if (selectedSeason != 'All') {
      filtered = filtered
          .where((item) => item.season == selectedSeason)
          .toList();
    }

    emit(ClosetState.success(filtered));
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
          // Remove the item from the list and emit the updated list
          allItems.removeWhere((item) => item.id == itemId);
          // Also refresh the filtered view
          _applyFilters();
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
}
