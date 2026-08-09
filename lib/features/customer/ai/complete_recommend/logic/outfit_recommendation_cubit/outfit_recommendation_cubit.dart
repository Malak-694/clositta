import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/helper/shared_key.dart';
import '../../data/models/daily_outfit_request_model.dart';
import '../../data/models/daily_outfit_response_model.dart';
import '../../data/repo/outfit_recommendation_repo.dart';
import 'outfit_recommendation_state.dart';

class OutfitRecommendationCubit
    extends Cubit<OutfitRecommendationState<DailyOutfitRecommendationResponse>> {
  final OutfitRecommendationRepo repo;
  final SharedPrefHelper sharedPrefHelper;

  OutfitRecommendationCubit(this.repo, this.sharedPrefHelper)
      : super(const OutfitRecommendationState.initial());

  Future<void> getRecommendation({
    required String occasion,
    required String season,
  }) async {
    emit(const OutfitRecommendationState.loading());
    try {
      final token = await sharedPrefHelper.getSecureData(SharedPrefKey.token);
      final userId = await sharedPrefHelper.getSecureData(SharedPrefKey.id);

      final response = await repo.getDailyOutfitRecommendation(
        token: "Bearer $token",
        body: DailyOutfitRequestModel(
          userId: userId ?? '',
          occasion: occasion.toLowerCase(),
          season: season.toLowerCase(),
        ),
      );

      emit(OutfitRecommendationState.success(response));
    } catch (e) {
      emit(OutfitRecommendationState.fail(e.toString()));
    }
  }
}