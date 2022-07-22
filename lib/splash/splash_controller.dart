import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:permission_handler/permission_handler.dart';
import 'package:serproapp/routes/routes.dart';

class SplashController extends ChangeNotifier{
  final Permission _locationPermission;
  String _routName;
  String get routName => _routName; 
  SplashController(this._locationPermission);

  Future<void> checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    _routName = isGranted?Routes.HOME:Routes.PERMISSION;
    notifyListeners();
  }
}