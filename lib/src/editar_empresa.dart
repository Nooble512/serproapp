// ignore_for_file: use_build_context_synchronously, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:serproapp/model/EmpresaDuenioModel.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/src/empresa_duenio.dart';
import 'package:serproapp/src/inicio.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class EditarEmpresa extends StatefulWidget {
  String token;
  EmpresaDuenioModel empresa;
  EditarEmpresa(this.token, this.empresa, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<EditarEmpresa> createState() => _EditarEmpresaState(token, empresa);
}

class _EditarEmpresaState extends State<EditarEmpresa> {
  String token;
  EmpresaDuenioModel empresa;
  _EditarEmpresaState(this.token, this.empresa);

  LatLng posicion;

  @override
  void initState() {
    posicion = LatLng(double.parse(empresa.latitud), double.parse(empresa.longitud));
    super.initState();
  }

  // Widget para el campo de nombre
  Widget _nombre(){
    return SizedBox(
      width: 400,
      child: TextField(
        controller: TextEditingController(text: empresa.nombre),
        decoration: const InputDecoration(
          labelText: "Nombre",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          empresa.nombre = value;
        },
      ),
    );
  }  

  // Widget para el campo de descripcion
  Widget _descripcion(){
    return SizedBox(
      width: 400,
      child: TextField(
        maxLines: 5,
        controller: TextEditingController(text: empresa.descripcion),
        decoration: const InputDecoration(
          labelText: "Descripción",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          empresa.descripcion = value;
        },
      ),
    );
  }

  // Widget para el campo de telefono
  Widget _telefono(){
    return SizedBox(
      width: 400,
      child: TextField(
        controller: TextEditingController(text: empresa.telefono.toString()),
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Teléfono",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          empresa.telefono = value;
        },
      ),
    );
  }

  // Widget para mapa de ubicacion con GoogleMaps
  Widget _ubicacion(){
    final Map<MarkerId, Marker> markers = {};
    final Marker marker = Marker(markerId: const MarkerId('1'), position: LatLng(double.parse(empresa.latitud), double.parse(empresa.longitud)));
    markers[const MarkerId('0')] = marker;

    return SizedBox(
      height: 300,
      width: 450,
      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(empresa.latitud), double.parse(empresa.longitud)),
          zoom: 17,
        ),
        markers: markers.values.toSet(),
        onTap: (LatLng position) {
          setState(() {
            posicion = position;
            empresa.latitud = posicion.latitude.toString();
            empresa.longitud = posicion.longitude.toString();
            markers[const MarkerId('0')] = Marker(markerId: const MarkerId('0'), position: posicion);
          });
        },
      ),
    );
  }

  // Boton guardar cambios
  Widget _botonGuardar(){
    return ElevatedButton(
      child: const Text("Guardar"),
      onPressed: () {
        if (empresa.nombre == "" || empresa.descripcion == "" || empresa.telefono == "") {
          Toast.show("Todos los campos son obligatorios", context, duration: Toast.LENGTH_LONG);
        } else {
          actualizarEmpresa();
        }
      },
    );
  }

  void actualizarEmpresa() async {
    String url = "${UrlApi().url}/api/empresa";

    Map<String, String> body = {
      'nombre': empresa.nombre,
      'descripcion': empresa.descripcion,
      'telefono': empresa.telefono.toString(),
      'latitud': posicion.latitude.toString(),
      'longitud': posicion.longitude.toString(),
    };

    Uri uri = Uri.parse(url);
    final response = await http.put(uri, body: body, headers: { 'token':token });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio(token)));
      Navigator.push(context, MaterialPageRoute(builder: (context) => EmpresaDuenio(token)));
    } else if (response.statusCode == 400){
      Toast.show("Error al actualizar la empresa", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Error al conectar con el servidor", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Empresa'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text("Nombre de la empresa"),
              _nombre(),
              const SizedBox(height: 30),
              const Text("Descripcion de la empresa"),
              _descripcion(),
              const SizedBox(height: 30),
              const Text("Telefono de la empresa"),
              _telefono(),
              const SizedBox(height: 30),
              _ubicacion(),
              const SizedBox(height: 30),
              _botonGuardar(),
            ],
          ),
        ),
      ),
    );
  }
}