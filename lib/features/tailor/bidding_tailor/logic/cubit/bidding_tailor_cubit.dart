import 'package:bloc/bloc.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';

import '../../data/models/join_bidding_model.dart';
import '../../data/repo/bidding_tailor_repo.dart';
import '../../ui/widgets/post_item_tailor.dart';

class BiddingTailorCubit extends Cubit<BiddingTailorState> {
  final BiddingTailorRepo _repository;
  final SharedPrefHelper _prefs;

  BiddingTailorCubit({
    required BiddingTailorRepo repository,
    required SharedPrefHelper prefs,
  }) : _repository = repository,
       _prefs = prefs,
       super(const BiddingTailorState.initial());

  // Get token from shared preferences
  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  // Get bidding tailors (posts)
  Future<void> getBiddingTailors() async {
    emit(const BiddingTailorState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const BiddingTailorState.fail("Authentication token not found"));
        return;
      }

      final List<PostItemTailor> response = await _repository.getBiddingTailors(
        token,
      );
      emit(BiddingTailorState.success(response));
    } catch (e) {
      emit(
        BiddingTailorState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to load bidding posts. Please try again.",
        ),
      );
    }
  }

  // Get offers for a specific post
  Future<void> getOffers(String postId) async {
    emit(const BiddingTailorState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const BiddingTailorState.fail("Authentication token not found"));
        return;
      }

      final List<PostItemTailor> response = await _repository.getOffers(
        token,
        postId,
      );
      emit(BiddingTailorState.success(response));
    } catch (e) {
      emit(
        BiddingTailorState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to load offers. Please try again.",
        ),
      );
    }
  }

  // Join bidding for a specific post
  Future<void> joinBidding({
    required String postId,
    required JoinBiddingRequest request,
  }) async {
    emit(const BiddingTailorState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const BiddingTailorState.fail("Authentication token not found"));
        return;
      }

      final JoinBiddingResponse response = await _repository.joinBidding(
        token,
        postId,
        request,
      );
      emit(BiddingTailorState.success(response));
    } catch (e) {
      emit(
        BiddingTailorState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to join bidding. Please try again.",
        ),
      );
    }
  }

  // Refresh bidding tailors
  Future<void> refreshBiddingTailors() async {
    await getBiddingTailors();
  }

  // Clear state
  void clearState() {
    emit(const BiddingTailorState.initial());
  }
}
