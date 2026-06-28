import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/core/networking/dio_factory.dart';
import 'package:chicora/features/auth/data/repo/auth_repo.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/closet/data/repo/closet_repo.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_cubit.dart';
import 'package:chicora/features/customer/measurements/data/measurements_repo.dart';
import 'package:chicora/features/customer/measurements/logic/cubit/measurements_cubit.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/cart_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/order_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/rate_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/product_search_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/view_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/rate_products_logic/rate_products_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_cubit.dart';
import 'package:chicora/features/seller/analysis/data/analysis_seller_repo.dart';
import 'package:chicora/features/seller/analysis/logic/cubit/analysis_seller_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/repo/bidding_tailor_repo.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/seller/products/data/repo/seller_product_repo.dart';
import 'package:chicora/features/seller/orders/data/repo/order_mangement_repo.dart';
import 'package:chicora/features/seller/orders/logic/cubit/order_mangement_cubit.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/tailor/portfolio/logic/cubit/portfolio_tailor_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/chat/data/repo/chat_repo.dart';
import '../../features/chat/data/repo/conversations_repo.dart';
import '../../features/chat/logic/chat_cubit/chat_cubit.dart';
import '../../features/chat/logic/conversations_cubit/conversations_cubit.dart';
import '../../features/customer/biding/data/repo/bid_repo.dart';
import '../../features/customer/biding/data/repo/portfolio_repo.dart';
import '../../features/customer/biding/logic/cubit/portfolio_cubit/portfolio_cubit.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../../features/tailor/portfolio/data/repo/portfolio_tailor_repo.dart';
import '../networking/socket_service.dart';

final GetIt getIt = GetIt.instance;
Future<void> setupGetIt() async {
  Dio dio = DioFactory.getDio();

  await SharedPrefHelper.init();
  getIt.registerSingleton<SharedPrefHelper>(SharedPrefHelper());
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  //Authentication
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(apiService: getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  //profile
  getIt.registerFactory<ProfileCubit>(
        () => ProfileCubit(getIt<ProfileRepo>()),
  );
  getIt.registerFactory<ProfileRepo>(
        () => ProfileRepo(apiService: getIt<ApiService>()),
  );
  //BiddingTailor
  getIt.registerLazySingleton<BiddingTailorRepo>(
        () => BiddingTailorRepo(apiService: getIt()),
  );
  getIt.registerFactory<BiddingTailorCubit>(() => BiddingTailorCubit(getIt()));
  //BiddingCustomer
  getIt.registerLazySingleton<BiddingCustomerRepo>(
        () => BiddingCustomerRepo(apiService: getIt()),
  );
  getIt.registerFactory<CustomerBiddingCubit>(
        () => CustomerBiddingCubit(getIt()),
  );
  //SellerProduct
  getIt.registerLazySingleton<SellerProductRepo>(
        () => SellerProductRepo(apiService: getIt()),
  );
  getIt.registerFactory<SellerProductsCubit>(
        () => SellerProductsCubit(sellerProductRepo: getIt()),
  );
  //ViewProducts
  getIt.registerLazySingleton<ViewProductsRepo>(
        () => ViewProductsRepo(apiService: getIt()),
  );
  //Product search (mock)
  getIt.registerLazySingleton<ProductSearchRepo>(() => ProductSearchRepo(apiService: getIt()));
  getIt.registerFactory<ViewProductsCubit>(
        () => ViewProductsCubit(
          viewProductsRepo: getIt(),
          productSearchRepo: getIt(),
        ),
  );
  //RateProducts
  getIt.registerLazySingleton<RateProductsRepo>(
        () => RateProductsRepo(apiService: getIt()),
  );
  getIt.registerFactory<RateProductsCubit>(
        () => RateProductsCubit(rateProductsRepo: getIt()),
  );
  //Closet
  getIt.registerLazySingleton<ClosetRepo>(
        () => ClosetRepo(apiService: getIt()),
  );
  getIt.registerFactory<ClosetCubit>(
        () => ClosetCubit(closetRepo: getIt()),
  );
  //Measurements (mock)
  getIt.registerLazySingleton<MeasurementsRepo>(() => MeasurementsRepo(apiService: getIt()));
  getIt.registerFactory<MeasurementsCubit>(
    () => MeasurementsCubit(repo: getIt()),
  );
  //PortfolioTailor
  getIt.registerLazySingleton<PortfolioTailorRepo>(
        () => PortfolioTailorRepo(apiService: getIt()),
  );
  getIt.registerFactory<PortfolioTailorCubit>(
        () => PortfolioTailorCubit(portfolioTailorRepo: getIt()),
  );
  //Cart
  getIt.registerLazySingleton<CartRepo>(
        () => CartRepo(apiService: getIt()),
  );
  getIt.registerFactory<CartCubit>(
        () => CartCubit(cartRepo: getIt()),
  );
  //SellerAnalysis
  getIt.registerLazySingleton<AnalysisSellerRepo>(
    () => AnalysisSellerRepo(apiService: getIt()),
  );
  getIt.registerFactory<AnalysisSellerCubit>(
    () => AnalysisSellerCubit(getIt()),
  );
  //Order
  getIt.registerLazySingleton<OrderRepo>(
    () => OrderRepo(apiService: getIt()),
  );
  getIt.registerFactory<OrderCubit>(
    () => OrderCubit(getIt()),
  );
  //Seller orders management
  getIt.registerLazySingleton<OrderMangementRepo>(
    () => OrderMangementRepo(apiService: getIt()),
  );
  getIt.registerFactory<OrderMangementCubit>(
    () => OrderMangementCubit(repo: getIt()),
  );

  getIt.registerLazySingleton<SocketService>(() => SocketService());

  getIt.registerLazySingleton<ConversationsRepo>(
        () => ConversationsRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<ConversationsCubit>(
        () => ConversationsCubit(getIt<ConversationsRepo>()),
  );

  // Register ChatRepo
  getIt.registerLazySingleton<ChatRepo>(
        () => ChatRepo(getIt<ApiService>()),
  );

// Register ChatCubit (factory so a new instance is created each time)
  getIt.registerFactory<ChatCubit>(
        () => ChatCubit(
      getIt<SocketService>(),
      getIt<ChatRepo>(),
    ),
  );

  getIt.registerFactory(() => PortfolioRepo(apiService: getIt<ApiService>()));
  getIt.registerFactory(() => PortfolioCubit(getIt<PortfolioRepo>()));
}
