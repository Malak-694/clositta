// ignore_for_file: unused_field

import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/data/models/offer_model.dart';
import 'package:chicora/features/customer/biding/data/models/send_bidding_model.dart';
import 'package:chicora/features/customer/biding/data/repo/bid_repo.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_state.dart';

// ignore: unused_import
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

  Future<void> getMyBids() async {
    if (_loadedBids) return;
    emit(const CustomerBiddingState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CustomerBiddingState.fail("Authentication token not found"));
        return;
      }
      final response = await _repository.getMyBids(token);
      _loadedBids = true;
      emit(CustomerBiddingState.success(response)); // ✅ T = List<BidResponse>
    } catch (e) {
      emit(CustomerBiddingState.fail(_parseError(e, "Failed to load my bids")));
    }
  }

  Future<void> refreshMyBids() async {
    _loadedBids = false;
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
      await _repository.createBidWithFile(
        token: token,
        description: request.description,
        imagePath: request.imageUrl,
        price: request.price,
        time: request.time,
      );
      emit(const CustomerBiddingState.success("Bid created successfully!")); // ✅ T = String here
      await refreshMyBids();
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
      await _repository.updateBid(
        token: token,
        bidId: bidId,
        description: description,
        imagePath: imagePath,
        price: price,
        time: time,
      );
      emit(const CustomerBiddingState.success("Post updated successfully!"));
      await refreshMyBids();
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
      emit(const CustomerBiddingState.success("Bid deleted successfully"));
      await refreshMyBids();
    } catch (e) {
      emit(CustomerBiddingState.fail(_parseError(e, "Failed to delete bid")));
    }
  }

  String _parseError(Object e, String fallback) {
    final msg = e.toString();
    return msg.contains("Exception:") ? msg.split("Exception: ").last : fallback;
  }

  void clearState() {
    _loadedBids = false;
    emit(const CustomerBiddingState.initial());
  }
}