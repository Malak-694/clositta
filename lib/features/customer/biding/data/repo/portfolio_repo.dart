// lib/features/portfolio/data/repo/portfolio_repo.dart

import 'package:chicora/core/networking/api_service.dart';
import '../models/portfolio_item_model.dart';

class PortfolioRepo {
  final ApiService apiService;

  PortfolioRepo({required this.apiService});

  Future<List<PortfolioItem>> getPortfolio(String token, String tailorId) async {
    try {
      return await apiService.getPortfolio("Bearer $token", tailorId);
    } catch (e) {
      throw Exception("Failed to fetch portfolio: $e");
    }
  }
}