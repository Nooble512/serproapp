// ignore_for_file: use_build_context_synchronously, must_be_immutable, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/model/Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/src/datos_usuario.dart';
import 'package:serproapp/src/inicio.dart';
import 'package:toast/toast.dart';

class EditarUsuario extends StatefulWidget {
  String token;
  Usuario usuario;
  EditarUsuario(this.token, this.usuario, {Key key}) : super(key: key);

  @override
  // ignore: unnecessary_this
  State<EditarUsuario> createState() => _EditarUsuarioState(this.token, this.usuario);
}

class _EditarUsuarioState extends State<EditarUsuario> {
  String token;
  Usuario usuario;
  _EditarUsuarioState(this.token, this.usuario);

  // Widget para el campo de nombre
  Widget _nombre(){
    return SizedBox(
      width: 400,
      child: TextField(
        controller: TextEditingController(text: usuario.nombre),
        decoration: const InputDecoration(
          labelText: "Nombre",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          usuario.nombre = value;
        },
      ),
    );
  } 

  // Widget para el campo de apellido
  Widget _apellido(){
    return SizedBox(
      width: 400,
      child: TextField(
        controller: TextEditingController(text: usuario.apellido),
        decoration: const InputDecoration(
          labelText: "Apellido",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          usuario.apellido = value;
        },
      ),
    );
  }

  // Widget para el campo de email
  Widget _email(){
    return SizedBox(
      width: 400,
      child: TextField(
        controller: TextEditingController(text: usuario.correo),
        decoration: const InputDecoration(
          labelText: "Email",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          usuario.correo = value;
        },
      ),
    );
  }

  // Boton guardar cambios
  Widget _botonGuardar(){
    return ElevatedButton(
      child: const Text("Guardar"),
      onPressed: () {
        if (usuario.nombre == "" || usuario.apellido == "" || usuario.correo == "") {
          Toast.show("Todos los campos son obligatorios", context, duration: Toast.LENGTH_LONG);
        } else {
          actualizarUsuario();
        }
      },
    );
  }

  void actualizarUsuario() async{
    String url = "${UrlApi().url}/api/usuario";
    Map<String, String> body = {
      "nombre":usuario.nombre,
      "apellido":usuario.apellido,
      "correo":usuario.correo,
    };
    Uri uri = Uri.parse(url);
    final response = await http.put(uri, body: body, headers: {"token": token});
    if (response.statusCode == 200){
      Toast.show("Datos actualizados", context, duration: Toast.LENGTH_LONG);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio(token)));
      Navigator.push(context, MaterialPageRoute(builder: (context) => DatosUsuario(token)));
    } else if(response.statusCode == 400) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      Toast.show(jsonData['Error'], context, duration: Toast.LENGTH_LONG);
    } else {
      Toast.show("Error", context, duration: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar usuario"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Nombre del usuario"),
            _nombre(),
            const SizedBox(height: 100),
            const Text("Apellido del usuario"),
            _apellido(),
            const SizedBox(height: 100),
            const Text("Email del usuario"),
            _email(),
            const SizedBox(height: 100),
            _botonGuardar(),
          ],
        ),
      ),
    );
  }
}