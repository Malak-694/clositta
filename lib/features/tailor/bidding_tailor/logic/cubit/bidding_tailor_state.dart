import 'package:freezed_annotation/freezed_annotation.dart';

part 'bidding_tailor_state.freezed.dart';

@freezed
class BiddingTailorState<T> with _$BiddingTailorState {
  const factory BiddingTailorState.initial() = _Initial;
  const factory BiddingTailorState.loading() = Loading;
  const factory BiddingTailorState.success(T data) = Success<T>;
  const factory BiddingTailorState.fail(String message) = Fail;
}
