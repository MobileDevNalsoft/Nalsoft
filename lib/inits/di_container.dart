import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meals_management/APIClient/dio_client1.dart';
import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/APIClient/interceptor.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:meals_management/views/screens/emp_screens/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient1(AppConstants.BASE_URL1, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => DioClient2(AppConstants.BASE_URL2, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // View
  sl.registerLazySingleton(() => EmployeeHomeView(sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => AuthRepo(dioClient1: sl(), sharedPreferences: sl()));

  sl.registerFactory(() => AuthProvider(authRepo: sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
