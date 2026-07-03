import 'package:freezed_annotation/freezed_annotation.dart';
// ignore: unused_import
import '../../../data/models/offer_model.dart';

part 'customer_offers_state.freezed.dart';

@freezed
class AcceptedOffersState<T> with _$AcceptedOffersState<T> {
  const factory AcceptedOffersState.initial() = _Initial;
  const factory AcceptedOffersState.loading() = _Loading;
  const factory AcceptedOffersState.success(T data) = _Success;
  const factory AcceptedOffersState.fail(String message) = _Fail;
}