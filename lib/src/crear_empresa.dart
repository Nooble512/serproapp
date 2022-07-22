

// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serproapp/controller/crear_empresa_controller.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/src/inicio.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


// ignore: must_be_immutable
class CrearEmpresa extends StatefulWidget {
  String token;
  CrearEmpresa(this.token, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CrearEmpresa> createState() => _CrearEmpresaState(token);
}

String nombre = "";
String descripcion = "";
int telefono = 0;

// Widget para el campo de nombre
Widget buildNombre() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Nombre',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: TextField(
          onChanged: (value) {
            nombre = value;
          },
          style: const TextStyle(
            color: Colors.black87,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.add_business,
              color: Color(0xff0b619c),
            ),
            hintText: 'Nombre del negocio',
          ),
        ),
      ),
    ],
  );
}

// Widget para el campo de descripcion
Widget buildDescripcion() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Descripción',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: TextField(
          maxLines: 8,
          onChanged: (value) {
            descripcion = value;
          },
          style: const TextStyle(
            color: Colors.black87,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.description,
              color: Color(0xff0b619c),
            ),
            hintText: 'Descripción del serviocio que ofrece',
          ),
        ),
      ),
    ],
  );
}

// Widget para el campo de telefono
Widget buildTelefono() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Teléfono',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: TextField(
          onChanged: (value) {
            telefono = int.parse(value);
          },
          style: const TextStyle(
            color: Colors.black87,
          ),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 10),
            prefixIcon: Icon(
              Icons.phone,
              color: Color(0xff0b619c),
            ),
            hintText: 'Teléfono del negocio (10 dígitos)',
          ),
        ),
      ),
    ],
  );
}

// boton para crear la empresa
Widget buildSingUpBtn(BuildContext context, String token, LatLng posicion){
  return Container(
    padding: const EdgeInsets.symmetric(vertical:25),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: (){
        if (nombre == "" || descripcion == "" || telefono == 0) {
          Toast.show("Todos los campos son obligatorios", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        } else if (telefono.toString().length != 10) {
          Toast.show("El teléfono debe tener 10 dígitos", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        } else if (posicion == const LatLng(0, 0)){
          Toast.show("Toque el mapa para seleccionar una posicion", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        } else {
          createEmpresa(token, context, posicion);
        }
      },
      child: const Text('SerPro'),
    ),
  );
}

// funcion para crear la empresa
void createEmpresa(String token, BuildContext context, LatLng posicion) async {
  String  url = '${UrlApi().url}/api/empresa';

  Map<String, String> body = {
    'nombre': nombre,
    'descripcion': descripcion,
    'telefono': telefono.toString(),
    'latitud': posicion.latitude.toString(),
    'longitud': posicion.longitude.toString(),
  };

  Uri uri = Uri.parse(url);

  final response = await http.post(uri,headers: {'token': token},body: body);
  if (response.statusCode == 200) {
    Toast.show("Empresa creada correctamente", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio(token)));
  } else if (response.statusCode == 400) {
    final jsonData = json.decode(utf8.decode(response.bodyBytes));
    Toast.show(jsonData["Error"], context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  } else {
    Toast.show("Error al crear la empresa", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}


class _CrearEmpresaState extends State<CrearEmpresa> {
  

  String token;
  _CrearEmpresaState(this.token);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Crear negocio"),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                buildNombre(),
                const SizedBox(height: 30),
                buildDescripcion(),
                const SizedBox(height: 30),
                buildTelefono(),
                const SizedBox(height: 30),
                Consumer<HomeController>(
                  builder: (_,controller,__) => Column(
                    children: [
                      SizedBox(
                        height: 300,
                        width: 450,
                        child: GoogleMap(
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          markers: controller.markers,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: controller.initialPosition,
                            zoom: 15,
                          ),
                          onTap: controller.onTap,
                        ),
                      ),
                      const SizedBox(height: 30),
                      buildSingUpBtn(context, token, controller.posicion),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}