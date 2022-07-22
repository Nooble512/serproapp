import 'package:flutter/widgets.dart';
import 'package:serproapp/request_permisison/reques_permission_page.dart';
import 'package:serproapp/routes/routes.dart';
import 'package:serproapp/splash/splash_pages.dart';
import 'package:serproapp/src/login.dart';

Map<String, Widget Function(BuildContext)> appRoutes(){
  return {
    Routes.SPLASH: (_) => const SplashPages(),
    Routes.PERMISSION: (_) => const RequesPermissionPage(),
    Routes.HOME: (_) => const Login(),
  };
}