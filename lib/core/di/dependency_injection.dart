import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/core/networking/dio_factory.dart';
import 'package:chicora/features/auth/data/repo/auth_repo.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/repo/bidding_tailor_repo.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/customer/biding/data/repo/bid_repo.dart';

final GetIt getIt = GetIt.instance;
Future<void> setupGetIt() async {
  Dio dio = DioFactory.getDio();

  await SharedPrefHelper.init();
  getIt.registerSingleton<SharedPrefHelper>(SharedPrefHelper());
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  //Authentication
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(apiService: getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  //BiddingTailor
  getIt.registerLazySingleton<BiddingTailorRepo>(() => BiddingTailorRepo(apiService: getIt()));
  getIt.registerFactory<BiddingTailorCubit>(() => BiddingTailorCubit(getIt()));
  //BiddingCustomer
  getIt.registerLazySingleton<BiddingCustomerRepo>(() => BiddingCustomerRepo(apiService: getIt()));
  getIt.registerFactory<CustomerBiddingCubit>(()=>CustomerBiddingCubit(getIt()));
  
}
