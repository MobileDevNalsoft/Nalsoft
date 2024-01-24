import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Initialize {
  final getIt = GetIt.instance;

  void setup() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  }
}
