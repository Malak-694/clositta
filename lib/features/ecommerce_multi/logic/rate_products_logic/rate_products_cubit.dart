import 'package:bloc/bloc.dart';
import 'package:chicora/core/models/message_model.dart';
import 'package:chicora/core/networking/api_result.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/rate_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/rate_products_logic/rate_products_state.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helper/shared_key.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../data/models/rating models/rating_request_model.dart';
import '../../data/models/rating models/rating_response_model.dart';

class RateProductsCubit extends Cubit<RateProductsState> {
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  final RateProductsRepo rateProductsRepo;
  RateProductsCubit({required this.rateProductsRepo})
    : super(RateProductsState.initial());

  Future<void> rateProduct(String productId, int rating, String comment) async {
    emit(RateProductsState.loading());
    ApiResult<RatingResponseModel> result = await rateProductsRepo.rateProduct(
      await _prefs.getSecureData(SharedPrefKey.token) ?? '',
      productId,
      RatingRequestModel(rating, comment),
    );
    result.when(
      success: (RatingResponseModel ratedata) =>
          emit(RateProductsState.success(ratedata)),
      failure: (error) => emit(RateProductsState.fail(error)),
    );
  }

  Future<void> deleteRateProduct(String productId) async {
    emit(RateProductsState.loading());
    ApiResult<MessageModel> result = await rateProductsRepo.deleteRateProduct(
      await _prefs.getSecureData(SharedPrefKey.token) ?? '',
      productId,
    );
    result.when(
      success: (MessageModel message) =>
          emit(RateProductsState.success(message)),
      failure: (error) => emit(RateProductsState.fail(error)),
    );
  }
}
