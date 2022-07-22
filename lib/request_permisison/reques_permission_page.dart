import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:serproapp/request_permisison/request_permision_controller.dart';
import 'package:serproapp/routes/routes.dart';

class RequesPermissionPage extends StatefulWidget {
  const RequesPermissionPage({Key key}) : super(key: key);


  @override
  State<RequesPermissionPage> createState() => _RequesPermissionPageState();
}

class _RequesPermissionPageState extends State<RequesPermissionPage> {
  final _controller = RequesPermissionController(Permission.locationWhenInUse);
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _controller.onPermissionStatusChange.listen(
      (status) {
        if (status == PermissionStatus.granted){
          Navigator.pushReplacementNamed(context, Routes.HOME);
        }
      }
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.disponse();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Necesitamos el acceso a tu ubicación',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              child: const Text("Aceptar"),
              onPressed: () {
                _controller.request();
              },
            ),
          ],
        ),
      )
    );
  }
}