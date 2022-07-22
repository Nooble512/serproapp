// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class RequesPermissionController {
  final Permission _locationPermission;

  RequesPermissionController(this._locationPermission);

  final _streamController = StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get onPermissionStatusChange => _streamController.stream;

  request() async {
    final status = await _locationPermission.request();
    _notify(status);
  }

  void _notify(PermissionStatus status) {
    if(!_streamController.isClosed && _streamController.hasListener) {
      _streamController.add(status);
    }

  }

  void disponse(){
    _streamController.close();
  }
}