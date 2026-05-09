import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_bidding_state.freezed.dart';

@freezed
class CustomerBiddingState<T> with _$CustomerBiddingState<T> {
  const factory CustomerBiddingState.initial() = _Initial;
  const factory CustomerBiddingState.loading() = Loading;
  const factory CustomerBiddingState.success(T data) = Success<T>;
  const factory CustomerBiddingState.fail(String message) = Fail;
}