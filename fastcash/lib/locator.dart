
import 'package:fastcash/auth.dart';
import 'package:fastcash/notifications.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => PushNotificationService());
}