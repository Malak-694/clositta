import 'package:bloc/bloc.dart';
import 'package:chicora/features/tailor/portfolio/data/repo/portfolio_tailor_repo.dart';
import 'package:chicora/features/tailor/portfolio/data/models/portfolio_tailor_response_model.dart';
import 'package:chicora/features/tailor/portfolio/logic/cubit/portfolio_tailor_state.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/models/message_model.dart';
import '../../../../../core/networking/api_result.dart';

class PortfolioTailorCubit extends Cubit<PortfolioTailorState> {
  final PortfolioTailorRepo portfolioTailorRepo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  List<PortfolioTailorResponseModel> allItems = [];
  String selectedCategory = 'All';
  String selectedSeason = 'All';

  PortfolioTailorCubit({required this.portfolioTailorRepo})
    : super(PortfolioTailorState.initial());
  Future<String?> _getToken() async {
    return await _prefs.getSecureData(SharedPrefKey.token);
  }

  Future<void> viewPortfolioTailor(String? category) async {
    emit(PortfolioTailorState.loading());
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      emit(const PortfolioTailorState.fail("Authentication token not found"));
      return;
    }

    final result = await portfolioTailorRepo.viewPortfolioTailor(
      token,
      category,
    );
    result.when(
      success: (List<PortfolioTailorResponseModel> portfolioTailor) {
        allItems = portfolioTailor;
        selectedCategory = category ?? 'All';
        emit(PortfolioTailorState.success(portfolioTailor));
      },
      failure: (error) => emit(PortfolioTailorState.fail(error)),
    );
  }

  void filterByCategory(String category) {
    List<PortfolioTailorResponseModel> filtered = allItems;

    selectedCategory = category;
    if (selectedCategory != 'All') {
      filtered = filtered
          .where((item) => item.category == selectedCategory)
          .toList();
    }
    emit(PortfolioTailorState.success(filtered));
  }

  Future<void> deletePortfolioTailor(String itemId) async {
    emit(PortfolioTailorState.loading());
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      emit(const PortfolioTailorState.fail("Authentication token not found"));
      return;
    }
    final result = await portfolioTailorRepo.deletePortfolioTailor(
      token,
      itemId,
    );
    result.when(
      success: (MessageModel message) =>
          emit(PortfolioTailorState.success(message.message)),
      failure: (error) => emit(PortfolioTailorState.fail(error)),
    );
  }
}
