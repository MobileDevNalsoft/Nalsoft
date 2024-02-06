import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meals_management/APIClient/dio_client1.dart';
import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/APIClient/interceptor.dart';
import 'package:meals_management/providers/admin_employees_provider.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/providers/home_status_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/repositories/user_repo.dart';

import 'package:meals_management/utils/constants.dart';
import 'package:meals_management/views/screens/admin_screens/admin_home_view.dart';
import 'package:meals_management/views/screens/emp_screens/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.allowReassignment = true;
  // Core
  sl.registerLazySingleton(() => DioClient1(AppConstants.BASE_URL1, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => DioClient2(AppConstants.BASE_URL2, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => AuthenticationRepo(dioClient1: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => UserRepo(dioClient2: sl()));
  sl.registerLazySingleton(() => UserEventsRepo(dioClient2: sl()));
  

  sl.registerFactory(() => AuthenticationProvider(authenticationRepo: sl()));
  sl.registerFactory(
      () => UserDataProvider(userRepo: sl(), userEventsRepo: sl(), sharedPreferences: sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
