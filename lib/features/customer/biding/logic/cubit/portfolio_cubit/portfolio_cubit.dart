// lib/features/portfolio/logic/portfolio_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import '../../../data/repo/portfolio_repo.dart';
import 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  final PortfolioRepo _repo;
  final SharedPrefHelper _prefs = getIt<SharedPrefHelper>();

  PortfolioCubit(this._repo) : super(const PortfolioState.initial());

  Future<void> loadPortfolio(String tailorId) async {
    emit(const PortfolioState.loading());
    try {
      final token = await _prefs.getSecureData(SharedPrefKey.token);
      if (token == null || token.isEmpty) {
        emit(const PortfolioState.fail("Authentication token not found"));
        return;
      }
      final items = await _repo.getPortfolio(token, tailorId);
      emit(PortfolioState.success(items));
    } catch (e) {
      emit(PortfolioState.fail(
        e.toString().contains("Exception:")
            ? e.toString().split("Exception: ")[1]
            : "Failed to load portfolio.",
      ));
    }
  }
}