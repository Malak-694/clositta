import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_tailor_state.freezed.dart';

@freezed
class PortfolioTailorState<T> with _$PortfolioTailorState {
  const factory PortfolioTailorState.initial() = _Initial;
  const factory PortfolioTailorState.loading() = Loading;
  const factory PortfolioTailorState.success(T data) = Success<T>;
  const factory PortfolioTailorState.fail(String message) = Fail;
}
