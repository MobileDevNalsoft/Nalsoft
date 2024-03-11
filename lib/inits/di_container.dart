import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meals_management/APIClient/dio_client1.dart';
import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/APIClient/interceptor.dart';
import 'package:meals_management/providers/meals_management/admin_employees_provider.dart';
import 'package:meals_management/providers/meals_management/auth_provider.dart';
import 'package:meals_management/providers/meals_management/firebase_provider.dart';
import 'package:meals_management/providers/meals_management/user_data_provider.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/repositories/firebase_repo.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/repositories/user_repo.dart';
import 'package:meals_management/utils/constants.dart';
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
  sl.registerLazySingleton(() => FirebaseRepo(dioClient2: sl()));

  // Provider
  sl.registerFactory(() => AuthenticationProvider(authenticationRepo: sl()));
  sl.registerFactory(() => UserDataProvider(
      userRepo: sl(), userEventsRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() =>
      AdminEmployeesProvider(userEventsRepo: sl(), sharedPreferences: sl()));
        sl.registerFactory(() =>
      FirebaseProvider(firebaseRepo: sl(),));

  // Initializations
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerFactory(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
