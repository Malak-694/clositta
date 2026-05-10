

import 'package:freezed_annotation/freezed_annotation.dart';
part 'portfolio_state.freezed.dart';

@freezed
class PortfolioState with _$PortfolioState {
  const factory PortfolioState.initial()          = _Initial;
  const factory PortfolioState.loading()          = _Loading;
  const factory PortfolioState.success(dynamic data) = _Success;
  const factory PortfolioState.fail(String message)  = _Fail;
}