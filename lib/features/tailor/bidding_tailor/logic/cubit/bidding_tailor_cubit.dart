import 'package:bloc/bloc.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../data/models/bid_model.dart';
import '../../data/models/join_bidding_model.dart';
import '../../data/models/post_tailor_model.dart';
import '../../data/repo/bidding_tailor_repo.dart';

class BiddingTailorCubit extends Cubit<BiddingTailorState> {
  final BiddingTailorRepo _repository;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  BiddingTailorCubit(this._repository) : super(BiddingTailorState.initial());
  bool _loadedPosts = false;
  bool _loadedoOffers = false;

  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  Future<void> getBiddingTailors() async {
    if (_loadedPosts) return;
    emit(const BiddingTailorState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const BiddingTailorState.fail("Authentication token not found"));
        return;
      }
      final List<PostTailorResponse> response =
      await _repository.getBiddingTailors(token);
      emit(BiddingTailorState.success(response));
      _loadedPosts = true;
    } catch (e) {
      emit(BiddingTailorState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to load bidding posts. Please try again.",
      ));
    }
  }

  Future<void> getOffers(String postId) async {
    if (_loadedoOffers) return;
    emit(const BiddingTailorState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const BiddingTailorState.fail("Authentication token not found"));
        return;
      }
      print(token);
      final List<BidModelReponse> response =
      await _repository.getOffers(token, postId);
      emit(BiddingTailorState.success(response));
      _loadedoOffers = true;
    } catch (e) {
      emit(BiddingTailorState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to load offers. Please try again.",
      ));
    }
  }

  // ✅ Always reloads — bypasses the _loadedoOffers flag
  Future<void> refreshOffers(String postId) async {
    _loadedoOffers = false;
    await getOffers(postId);
  }

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
      final JoinBiddingResponse response =
      await _repository.joinBidding(token, postId, request);
      emit(BiddingTailorState.success(response));
    } catch (e) {
      emit(BiddingTailorState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to join bidding. Please try again.",
      ));
    }
  }

  Future<void> refreshBiddingTailors() async {
    await getBiddingTailors();
  }

  void clearState() {
    emit(const BiddingTailorState.initial());
  }

  Future<void> updateOffer({
    required String offerId,
    required String postId,
    String? price,
    String? timeInDays,
    String? message,
  }) async {
    emit(const BiddingTailorState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const BiddingTailorState.fail("Authentication token not found"));
        return;
      }

      await _repository.updateOffer(
        token: token,
        offerId: offerId,
        price: price,
        timeInDays: timeInDays,
        message: message,
      );

      // ✅ Reset flag so .then() in DetailesScreen can reload fresh data
      _loadedoOffers = false;
      if (!isClosed) {
        emit(const BiddingTailorState.success("Offer updated successfully"));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BiddingTailorState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to update offer.",
        ));
      }
    }
  }

  Future<void> deleteOffer({
    required String offerId,
    required String postId,
  }) async {
    emit(const BiddingTailorState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const BiddingTailorState.fail("Authentication token not found"));
        return;
      }

      await _repository.deleteOffer(token: token, offerId: offerId);

      // ✅ Reset flag then reload — delete stays on same screen
      _loadedoOffers = false;
      if (!isClosed) {
        emit(const BiddingTailorState.success("Offer deleted successfully"));
      }
      if (!isClosed) await getOffers(postId);
    } catch (e) {
      if (!isClosed) {
        emit(BiddingTailorState.fail(
          e.toString().contains("Exception:")
              ? e.toString().split("Exception: ")[1]
              : "Failed to delete offer.",
        ));
      }
    }
  }
}