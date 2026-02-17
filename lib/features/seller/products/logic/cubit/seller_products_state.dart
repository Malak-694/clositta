import 'package:freezed_annotation/freezed_annotation.dart';

part 'seller_products_state.freezed.dart';

@freezed
class SellerProductsState<T> with _$SellerProductsState<T> {
  const factory SellerProductsState.initial() = _Initial;
  const factory SellerProductsState.loading() = Loading;
  const factory SellerProductsState.success(T data) = Success;
  const factory SellerProductsState.fail(String error) =Fail;
}
