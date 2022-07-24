// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/src/empresa_duenio.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class NuevoCupon extends StatefulWidget {
  String token;
  NuevoCupon(this.token, {Key key}) : super(key: key);

  @override
  State<NuevoCupon> createState() => _NuevoCuponState(token);
}

class _NuevoCuponState extends State<NuevoCupon> {
  String token;
  _NuevoCuponState(this.token);

  String nombre = "";
  String descripcion = "";
  String cantidad = "";

  void _crearCuponPost() async {
    String url = '${UrlApi().url}/api/empresa/cupon/crear';
    Map <String, String> body = {
      'nombre': nombre,
      'descripcion': descripcion,
      'cantidad': cantidad,
    };
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, body: body, headers: {'token': token});
    if (response.statusCode == 200){
      Toast.show("Cupon creado correctamente", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => EmpresaDuenio(token)));
    } else if (response.statusCode == 400){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      Toast.show(jsonData["Error"], context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      Toast.show("Error al crear el cupon", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
    onPressed = 0;
  }

  // Widget para el campo de nombre
  Widget _nombre(){
    return SizedBox(
      width: 400,
      child: TextField(
        controller: TextEditingController(text: nombre),
        decoration: const InputDecoration(
          labelText: "Nombre del cupon",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          nombre = value;
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
        controller: TextEditingController(text: descripcion),
        decoration: const InputDecoration(
          labelText: "Descripción del cupon",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          descripcion = value;
        },
      ),
    );
  }

  // Widget para el campo de cantidad
  Widget _cantidad(){
    return SizedBox(
      width: 400,
      child: TextField(
        controller: TextEditingController(text: cantidad),
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Cantidad del cupon",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          cantidad = value;
        },
      ),
    );
  }

  int onPressed = 0;

  // Boton para crear el cupon
  ElevatedButton _crearCupon(){
    return ElevatedButton (
      child: const Text("Crear cupon"),
      onPressed: () {
        if (nombre == "" || descripcion == "" || cantidad == "") {
          Toast.show("Todos los campos son obligatorios", context, duration: Toast.LENGTH_LONG);
        } else {
          if (onPressed == 0) {
            onPressed = 1;
            _crearCuponPost();
          } else {
            Toast.show("Espere un momento", context, duration: Toast.LENGTH_LONG);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo cupón"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              const Text('Nombre',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _nombre(),
              const SizedBox(height: 50),
              const Text('Descripción',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _descripcion(),
              const SizedBox(height: 50),
              const Text('Cantidad',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _cantidad(),
              const SizedBox(height: 50),
              _crearCupon(),
            ],
          ),
        ),
      ),
    );
  }
}