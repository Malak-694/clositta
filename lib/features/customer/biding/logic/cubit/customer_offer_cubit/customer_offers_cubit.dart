import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import '../../../data/models/rate_offer_request_model.dart';
import '../../../data/repo/bid_repo.dart';
import 'customer_offers_state.dart';

class CustomerOffersCubit extends Cubit<AcceptedOffersState> {
  final BiddingCustomerRepo _repository;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  CustomerOffersCubit(this._repository) : super(const AcceptedOffersState.initial());

  bool _loadedAcceptedOffers = false;
  bool _loadedOffers = false;
  bool _loadedBestOffers = false;

  Future<String?> _getToken() async => await _prefs.getSecureData(SharedPrefKey.token);

  // ── Accepted Offers (Active Orders tab) ─────────────────────────────

  Future<void> loadAcceptedOffers() async {
    if (_loadedAcceptedOffers) return;
    emit(const AcceptedOffersState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const AcceptedOffersState.fail("Authentication token not found"));
        return;
      }
      final offers = await _repository.getCustomerAcceptedOffers(token);
      _loadedAcceptedOffers = true;
      emit(AcceptedOffersState.success(offers));
    } catch (e) {
      emit(AcceptedOffersState.fail(_parseError(e, "Failed to load active orders")));
    }
  }

  Future<void> refreshAcceptedOffers() async {
    _loadedAcceptedOffers = false;
    await loadAcceptedOffers();
  }

  // ── All Offers on a bid ──────────────────────────────────────────────

  Future<void> getOffers(String postId) async {
    if (_loadedOffers) return;
    emit(const AcceptedOffersState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const AcceptedOffersState.fail("Authentication token not found"));
        return;
      }
      final offers = await _repository.getOffers(token, postId);
      _loadedOffers = true;
      emit(AcceptedOffersState.success(offers));
    } catch (e) {
      emit(AcceptedOffersState.fail(_parseError(e, "Failed to load offers")));
    }
  }

  Future<void> refreshOffers(String postId) async {
    _loadedOffers = false;
    await getOffers(postId);
  }

  // ── Best Offers on a bid ─────────────────────────────────────────────

  Future<void> getBestOffers(String bidId) async {
    if (_loadedBestOffers) return;
    emit(const AcceptedOffersState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const AcceptedOffersState.fail("Authentication token not found"));
        return;
      }
      final offers = await _repository.getBestOffers(token, bidId);
      _loadedBestOffers = true;
      emit(AcceptedOffersState.success(offers));
    } catch (e) {
      emit(AcceptedOffersState.fail(_parseError(e, "Failed to load best offers")));
    }
  }

  Future<void> refreshBestOffers(String bidId) async {
    _loadedBestOffers = false;
    await getBestOffers(bidId);
  }

  // ── Accept / Rate ─────────────────────────────────────────────────────

  Future<void> acceptOffer(String offerId, String bidId) async {
    emit(const AcceptedOffersState.loading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const AcceptedOffersState.fail("Authentication token not found"));
        return;
      }
      await _repository.acceptOffer(token, offerId);

      _loadedBestOffers = false;
      await getBestOffers(bidId); // refresh best offers after accepting
    } catch (e) {
      emit(AcceptedOffersState.fail(_parseError(e, "Failed to accept offer")));
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

  String _parseError(Object e, String fallback) {
    final msg = e.toString();
    return msg.contains("Exception:") ? msg.split("Exception: ").last : fallback;
  }

  void clearState() {
    _loadedAcceptedOffers = false;
    _loadedOffers = false;
    _loadedBestOffers = false;
    emit(const AcceptedOffersState.initial());
  }
}