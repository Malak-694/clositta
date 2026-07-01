import 'package:freezed_annotation/freezed_annotation.dart';

part 'outfit_recommendation_state.freezed.dart';

@freezed
class OutfitRecommendationState<T> with _$OutfitRecommendationState<T> {
  const factory OutfitRecommendationState.initial() = _Initial;
  const factory OutfitRecommendationState.loading() = Loading;
  const factory OutfitRecommendationState.success(T data) = Success<T>;
  const factory OutfitRecommendationState.fail(String message) = Fail;
}