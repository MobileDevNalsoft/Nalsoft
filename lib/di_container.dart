
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meals_management/APIClient/dio_client1.dart';
import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/APIClient/interceptor.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



final sl = GetIt.instance;

Future<void> init() async {
  // Core
  // print(sl());
  sl.registerLazySingleton(() => DioClient1(Constants.BASE_URL1, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));
       sl.registerLazySingleton(() => DioClient2(Constants.BASE_URL2, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
    sl.registerLazySingleton(() => UserEventsRepo(dioClient: sl(), sharedPreferences: sl()));
 
  //Providers
  sl.registerLazySingleton(() => AuthenticationProvider(authRepo: sl()));
     sl.registerLazySingleton(() => UserDataProvider( userEventsRepo: sl()));

 final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}