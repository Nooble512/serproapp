import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:serproapp/splash/splash_controller.dart';

class SplashPages extends StatefulWidget {
  const SplashPages({Key key}) : super(key: key);


  @override
  State<SplashPages> createState() => _SplashPagesState();
}

class _SplashPagesState extends State<SplashPages> {
  final _controller = SplashController(Permission.locationWhenInUse);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.checkPermission();
    });
    _controller.addListener(() {
      if(_controller.routName != null){
        Navigator.pushReplacementNamed(context, _controller.routName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}