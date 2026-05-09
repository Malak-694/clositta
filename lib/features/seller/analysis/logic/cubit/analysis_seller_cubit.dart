import 'package:bloc/bloc.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/networking/api_result.dart';
import '../../data/analysis_seller_repo.dart';
import 'analysis_seller_state.dart';


class AnalysisSellerCubit extends Cubit<AnalysisSellerState> {
  final AnalysisSellerRepo _repository;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  AnalysisSellerCubit(this._repository) : super(AnalysisSellerState.initial());
  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

   Future<void> getSellerAnalysis() async {
    emit(AnalysisSellerState.loading());
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      emit(AnalysisSellerState.fail("Authentication token not found"));
      return;
    }
    final result = await _repository.getSellerAnalysis(token);
    result.when(success: (data) => emit(AnalysisSellerState.success(data)), failure: (error) => emit(AnalysisSellerState.fail(error)));
  }
  
 

}

 