import 'package:flutter/material.dart';
import 'package:serproapp/routes/pages.dart';
import 'package:serproapp/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.SPLASH,
      routes: appRoutes(),
    );
  }
}