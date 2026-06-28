import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/data/models/offer_model.dart';
import 'package:chicora/features/customer/biding/data/models/send_bidding_model.dart';
import 'package:chicora/features/customer/biding/data/repo/bid_repo.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_state.dart';

import '../../../data/models/rate_offer_request_model.dart';

class CustomerBiddingCubit extends Cubit<CustomerBiddingState> {
  final BiddingCustomerRepo _repository;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  CustomerBiddingCubit(this._repository)
      : super(const CustomerBiddingState.initial());

  bool _loadedBids = false;
  bool _loadedBestOffers = false;
  bool _loadedOffers = false;
  bool _loadedAcceptedOffers = false;

  List<BidResponse> _cachedBids = [];
  List<OfferResponse> _cachedAcceptedOffers = [];
  List<OfferResponse> get cachedAcceptedOffers => _cachedAcceptedOffers;

  // ── Auth ──────────────────────────────────────────────────────────────────

  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  // ── Bids ──────────────────────────────────────────────────────────────────

  Future<void> getMyBids() async {
    if (_loadedBids) return;
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      final List<BidResponse> response = await _repository.getMyBids(token);
      _cachedBids = response;
      emit(CustomerBiddingState.success(response));
      _loadedBids = true;
    } catch (e) {
      emit(CustomerBiddingState.fail(_parseError(e, "Failed to load my bids")));
    }
  }

  Future<void> refreshMyBids() async {
    _loadedBids = false;
    _cachedBids = [];
    await getMyBids();
  }

  Future<void> createBid({required SendBiddingModel request}) async {
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      if (request.imageUrl.isEmpty) {
        emit(const CustomerBiddingState.fail("Please select an image"));
        return;
      }

      final BidResponse response = await _repository.createBidWithFile(
        token: token,
        description: request.description,
        imagePath: request.imageUrl,
        price: request.price,
        time: request.time,
      );

      emit(CustomerBiddingState.success(response));
    } catch (e) {
      emit(CustomerBiddingState.fail(_parseError(e, "Failed to create bid")));
    }
  }

  Future<void> updateBid({
    required String bidId,
    required String description,
    String? imagePath,
    double? price,
    String? time,
  }) async {
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      final BidResponse response = await _repository.updateBid(
        token: token,
        bidId: bidId,
        description: description,
        imagePath: imagePath,
        price: price,
        time: time,
      );

      _loadedBids = false;
      _cachedBids = [];
      emit(CustomerBiddingState.success(response));
    } catch (e) {
      emit(CustomerBiddingState.fail(_parseError(e, "Failed to update bid")));
    }
  }

  Future<void> deleteBid({required String bidId}) async {
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      await _repository.deleteBid(token: token, bidId: bidId);

      _loadedBids = false;
      _cachedBids = [];
      emit(const CustomerBiddingState.success("Bid deleted successfully"));
    } catch (e) {
      emit(CustomerBiddingState.fail(_parseError(e, "Failed to delete bid")));
    }
  }

  // ── Offers ────────────────────────────────────────────────────────────────

  Future<void> getOffers(String postId) async {
    if (_loadedOffers) return;
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      final List<OfferResponse> response =
      await _repository.getOffers(token, postId);
      emit(CustomerBiddingState.success(response));
      _loadedOffers = true;
    } catch (e) {
      emit(CustomerBiddingState.fail(_parseError(e, "Failed to load offers")));
    }
  }

  Future<void> refreshOffers(String postId) async {
    _loadedOffers = false;
    await getOffers(postId);
  }

  Future<void> getBestOffers(String bidId) async {
    if (_loadedBestOffers) return;
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      final List<OfferResponse> response =
      await _repository.getBestOffers(token, bidId);
      emit(CustomerBiddingState.success(response));
      _loadedBestOffers = true;
    } catch (e) {
      emit(CustomerBiddingState.fail(
          _parseError(e, "Failed to load best offers")));
    }
  }

  Future<void> refreshBestOffers(String bidId) async {
    _loadedBestOffers = false;
    await getBestOffers(bidId);
  }

  Future<void> acceptOffer(String offerId, String bidId) async {
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      await _repository.acceptOffer(token, offerId);
      emit(const CustomerBiddingState.success("Offer accepted successfully"));

      _loadedBestOffers = false;
      await getBestOffers(bidId);
    } catch (e) {
      emit(CustomerBiddingState.fail(_parseError(e, "Failed to accept offer")));
    }
  }

  Future<void> rateOffer({
    required String offerId,
    required int rating,
    String? comment,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      await _repository.rateOffer(
        token: token,
        offerId: offerId,
        body: RateOfferRequestModel(rating: rating, comment: comment),
      );
    } catch (e) {
      throw Exception(_parseError(e, "Failed to submit rating"));
    }
  }

  // ── Active Orders (replaces old mapping approach) ─────────────────────────

  Future<void> loadAcceptedOffers() async {
    if (_loadedAcceptedOffers) return;
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }

      _cachedAcceptedOffers =
      await _repository.getCustomerAcceptedOffers(token);
      _loadedAcceptedOffers = true;

      emit(CustomerBiddingState.success(_cachedAcceptedOffers));
    } catch (e) {
      emit(CustomerBiddingState.fail(
          _parseError(e, "Failed to load active orders")));
    }
  }

  Future<void> refreshAcceptedOffers() async {
    _loadedAcceptedOffers = false;
    _cachedAcceptedOffers = [];
    await loadAcceptedOffers();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _parseError(Object e, String fallback) {
    final msg = e.toString();
    return msg.contains("Exception:")
        ? msg.split("Exception: ").last
        : fallback;
  }

  void clearState() {
    _loadedBids = false;
    _loadedBestOffers = false;
    _loadedOffers = false;
    _loadedAcceptedOffers = false;
    _cachedBids = [];
    _cachedAcceptedOffers = [];
    emit(const CustomerBiddingState.initial());
  }
}