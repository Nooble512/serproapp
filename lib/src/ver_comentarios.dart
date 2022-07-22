import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serproapp/model/Comentario.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:http/http.dart' as http;

class VerComentarios extends StatefulWidget {
  int id_emp;
  String token;
  VerComentarios( this.id_emp, this.token, {Key key}) : super(key: key);

  @override
  State<VerComentarios> createState() => _VerComentariosState(id_emp, token);
}

class _VerComentariosState extends State<VerComentarios> {
  int id_emp;
  String token;
  _VerComentariosState(this.id_emp, this.token);

  Future<List<Comentario>> _comentarios;
  Future<List<Comentario>> _getComentario() async {
    String url = '${UrlApi().url}/api/empresa/comentario/todos';
    Map<String, String> body = {
      "id_emp": "$id_emp"
    };
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, body: body, headers: {"token": token});
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Comentario> comentarios = [];
      for (var item in jsonData) {
        Comentario comentario = Comentario(
          item["id"], 
          item["id_usu"], 
          item["id_emp"], 
          item["calificacion"], 
          item["descripcion"],
          item["nombre"],
          item["apellido"],
          item["imagen"],
          item["correo"]
        );
        comentarios.add(comentario);
      }
      return comentarios;
    } else {
      throw Exception('Error');
    }
  }

  @override
  void initState() {
    _comentarios = _getComentario();
    super.initState();
  }

  FutureBuilder _center (){
    return FutureBuilder(
      future: _comentarios,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data[index].imagen),
                ),
                title: Text(snapshot.data[index].nombre + " " + snapshot.data[index].apellido),
                subtitle: Text(snapshot.data[index].descripcion),
                trailing: Text("${snapshot.data[index].calificacion.toString()}/5"),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error al obtener los comentarios"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
      ),
      body: _center(),
    );
  }
}