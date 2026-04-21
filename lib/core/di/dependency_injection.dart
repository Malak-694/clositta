import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/core/networking/dio_factory.dart';
import 'package:chicora/features/auth/data/repo/auth_repo.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/closet/data/repo/closet_repo.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_cubit.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/cart_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/order_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/rate_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/data/repo/view_products_repo.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/order_cubit/order_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/rate_products_logic/rate_products_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/repo/bidding_tailor_repo.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/seller/products/data/repo/seller_product_repo.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/tailor/portfolio/logic/cubit/portfolio_tailor_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/customer/biding/data/repo/bid_repo.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../../features/tailor/portfolio/data/repo/portfolio_tailor_repo.dart';

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
  getIt.registerFactory<ViewProductsCubit>(
    () => ViewProductsCubit(viewProductsRepo: getIt()),
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
  //Order
  getIt.registerLazySingleton<OrderRepo>(
    () => OrderRepo(apiService: getIt()),
  );
  getIt.registerFactory<OrderCubit>(
    () => OrderCubit(getIt()),
  );

}
