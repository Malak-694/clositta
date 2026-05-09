import 'package:bloc/bloc.dart';
import 'package:chicora/features/tailor/portfolio/data/repo/portfolio_tailor_repo.dart';
import 'package:chicora/features/tailor/portfolio/data/models/portfolio_tailor_response_model.dart';
import 'package:chicora/features/tailor/portfolio/data/models/portfolio_tailor_user_model.dart';
import 'package:chicora/features/tailor/portfolio/data/models/tailor_portfolio_bundle_model.dart';
import 'package:chicora/features/tailor/portfolio/logic/cubit/portfolio_tailor_state.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helper/shared_key.dart';
import '../../../../../core/helper/shared_pref_helper.dart';
import '../../../../../core/networking/api_result.dart';

class PortfolioTailorCubit extends Cubit<PortfolioTailorState> {
  final PortfolioTailorRepo portfolioTailorRepo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();
  List<PortfolioTailorResponseModel> allItems = [];
  String selectedCategory = 'All';

  PortfolioTailorUserModel? tailorSummary;

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
      success: (TailorPortfolioBundleModel bundle) {
        tailorSummary = bundle.tailor;
        allItems = bundle.items;
        selectedCategory = category ?? 'All';
        emit(PortfolioTailorState.success(_filteredItems()));
      },
      failure: (error) => emit(PortfolioTailorState.fail(error)),
    );
  }

  List<PortfolioTailorResponseModel> _filteredItems() {
    if (selectedCategory == 'All') return List.from(allItems);
    return allItems
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    emit(PortfolioTailorState.success(_filteredItems()));
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
      success: (_) {
        allItems.removeWhere((e) => e.id == itemId);
        emit(PortfolioTailorState.success(_filteredItems()));
      },
      failure: (error) => emit(PortfolioTailorState.fail(error)),
    );
  }

  Future<void> addPortfolioItem({
    required String title,
    required String category,
    required String description,
    required String imagePath,
  }) async {
    emit(PortfolioTailorState.loading());
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      emit(const PortfolioTailorState.fail("Authentication token not found"));
      return;
    }

    final respose = await portfolioTailorRepo.addPortfolioItem(
      token: token,
      title: title,
      category: category,
      description: description,
      imagePath: imagePath,
    );

    await respose.when(
      success: (_) async {
        await viewPortfolioTailor(null);
      },
      failure: (message) async {
        emit(PortfolioTailorState.fail(message));
      },
    );
  }

  Future<void> updatePortfolioItem({
    required String itemId,
    required String title,
    required String category,
    required String description,
    String? imagePath,
  }) async {
    emit(PortfolioTailorState.loading());
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      emit(const PortfolioTailorState.fail("Authentication token not found"));
      return;
    }

    final response = await portfolioTailorRepo.updatePortfolioItem(
      token: token,
      itemId: itemId,
      title: title,
      category: category,
      description: description,
      imagePath: imagePath,
    );

    await response.when(
      success: (_) async {
        await viewPortfolioTailor(null);
      },
      failure: (message) async {
        emit(PortfolioTailorState.fail(message));
      },
    );
  }
}
