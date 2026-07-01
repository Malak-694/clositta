import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/complete_outfit_request_model.dart';
import '../../data/models/complete_outfit_response_model.dart';
import '../../data/repo/complete_outfit_repo.dart';
import 'complete_outfit_state.dart';

class CompleteOutfitCubit extends Cubit<CompleteOutfitState<CompleteOutfitResponseModel>> {
  final CompleteOutfitRepo repo;
  CompleteOutfitCubit(this.repo) : super(const CompleteOutfitState.initial());

  Future<void> getCompleteOutfit({
    required String imagePath,
    required CompleteOutfitRequestModel body,
  }) async {
    emit(const CompleteOutfitState.loading());
    try {
      final response = await repo.getCompleteOutfit(imagePath: imagePath, body: body);
      emit(CompleteOutfitState.success(response));
    } catch (e) {
      emit(CompleteOutfitState.fail(e.toString()));
    }
  }
}