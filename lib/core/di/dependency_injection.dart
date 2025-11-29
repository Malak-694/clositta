import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/networking/api_service.dart';
import 'package:chicora/core/networking/dio_factory.dart';
import 'package:chicora/features/auth/data/repo/auth_repo.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;
Future<void> setupGetIt() async {
  Dio dio = DioFactory.getDio();

  await SharedPrefHelper.init();
  getIt.registerSingleton<SharedPrefHelper>(SharedPrefHelper());

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(apiService: getIt()));
  getIt.registerSingleton<AuthCubit>(AuthCubit(getIt()));
}
