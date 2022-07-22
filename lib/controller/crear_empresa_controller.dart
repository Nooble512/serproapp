// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends ChangeNotifier{
  final Map<MarkerId, Marker> _markers = {};

  LatLng posicion = const LatLng(0, 0);
  LatLng _initialPosition = const LatLng(19.426857, -99.168010);
  LatLng get initialPosition => _initialPosition;

  Set<Marker> get markers => _markers.values.toSet();

  bool _loading = true;
  bool get loading => _loading;

  bool _gpsenabled;
  bool get gpsenabled => _gpsenabled;

  HomeController(){
    _init();
  }

  Future<void> _init() async{
    _gpsenabled = await Geolocator.isLocationServiceEnabled();

    _loading = false;
    Geolocator.getServiceStatusStream().listen(
      (status) async { 
        _gpsenabled = status == ServiceStatus.enabled;
        final initialPositionXD = await Geolocator.getCurrentPosition();
        _initialPosition = LatLng(initialPositionXD.latitude, initialPositionXD.longitude);
        notifyListeners();
      }
    );
    final initialPositionXD  = await Geolocator.getCurrentPosition();
    _initialPosition = LatLng(initialPositionXD.latitude, initialPositionXD.longitude);
    
    notifyListeners();
  }

  void onTap(LatLng position){
    print(position);
    posicion = position;
    final markerId = MarkerId(0.toString());
    final marker  = Marker(markerId: markerId, position: position); 
    _markers[markerId] = marker;
    notifyListeners();
  }

}