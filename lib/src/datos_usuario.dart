// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/model/Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/src/cambiar_img_usr.dart';
import 'package:serproapp/src/editar_usuario.dart';

class DatosUsuario extends StatefulWidget {
  String token;
  DatosUsuario(this.token, {Key key}) : super(key: key);

  @override
  State<DatosUsuario> createState() => _DatosUsuarioState(token);
}

class _DatosUsuarioState extends State<DatosUsuario> {
  String token;
  _DatosUsuarioState(this.token);

  Future<Usuario> _user;
  Future<Usuario> _getUser() async{
    String url = "${UrlApi().url}/api/usuario";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: {"token": token});
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      Usuario user = Usuario(
        jsonData["id"], 
        jsonData["nombre"], 
        jsonData["apellido"], 
        jsonData["correo"], 
        jsonData["contrasenia"], 
        jsonData["activo"], 
        jsonData["imagen"]
      );
      return user;
    } else {
      throw Exception('Error');
    }
  }
  
  @override
  void initState() {
    _user = _getUser();
    super.initState();
  }

  Widget _botonEditarDatos(Usuario user){
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditarUsuario(token, user)));
        },
        child: const Text(
          'Cambiar datos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _botonEditarImagen(){
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CambiarImgUsr(token)));
        },
        child: const Text(
          'Editar imagen de perfil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Column _buildColumn(BuildContext context, Usuario user) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 30),
        Image.network(
          user.imagen,
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 30),
        _botonEditarImagen(),
        const SizedBox(height: 30),
        const Text("Nombre"),
        Text(
          user.nombre,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const Text("Apellido"),
        Text(
          user.apellido,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const Text("Correo"),
        Text(
          user.correo,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        _botonEditarDatos(user),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos de usuario"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder(
            future: _user,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData){
                return _buildColumn(context, snapshot.data);
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      )
    );
  }
}