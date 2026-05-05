import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_seller_state.freezed.dart';

@freezed
  class AnalysisSellerState<T> with _$AnalysisSellerState<T> {
  const factory AnalysisSellerState.initial() = _Initial;
  const factory AnalysisSellerState.loading() = Loading;
  const factory AnalysisSellerState.success(T data) = Success<T>;
  const factory AnalysisSellerState.fail(String message) = Fail;
}