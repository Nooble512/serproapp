// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:serproapp/model/Comentario.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/src/empresa_general.dart';
import 'package:toast/toast.dart';

class EditarComentario extends StatefulWidget {
  String token;
  Comentario comentario;
  EditarComentario(this.token, this.comentario, {Key key}) : super(key: key);

  @override
  State<EditarComentario> createState() => _EditarComentarioState(this.token, this.comentario);
}

class _EditarComentarioState extends State<EditarComentario> {
  String token;
  Comentario comentario;
  _EditarComentarioState(this.token, this.comentario);

  int _rating = 5;
  String _comentario = "";
  int press = 0;

  @override
  void initState() {
    _rating = comentario.calificacion;
    _comentario = comentario.descripcion;
    super.initState();
  }

  Widget _descripcion(){
    return SizedBox(
      width: 400,
      child: TextField(
        maxLines: 5,
        controller: TextEditingController(text: comentario.descripcion),
        decoration: const InputDecoration(
          labelText: "Agrega un comentario",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          _comentario = value;
        },
      ),
    );
  }

  Widget _buildRatong(){
    return RatingBar(
      initialRating: comentario.calificacion.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      onRatingUpdate: (value) {
        setState(() {
          _rating = value.toInt();
        });
      }, 
      ratingWidget: RatingWidget(
        full: const Icon(Icons.star, color: Colors.amber),
        half: const Icon(Icons.star_half, color: Colors.amber),
        empty: const Icon(Icons.star_border, color: Colors.amber),
      )
    );
  }

  Widget _botonGuardar(){
    return ElevatedButton(
      child: const Text("Guardar"),
      onPressed: () {
        if (press == 0){
          if (_comentario.isEmpty) {
            Toast.show("Debes agregar un comentario", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          } else {
            press = 1;
            _guardarComentario();
          }
        } else {
          Toast.show("Actualizando comentario", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        }
      },
    );
  }

  void _guardarComentario() async {
    String url = "${UrlApi().url}/api/empresa/comentario/subir";
    Map<String, String> body = {
      "id_emp": '${comentario.id_emp}',
      "comentario" : _comentario,
      "calificacion" : '$_rating'
    };
    Uri uri = Uri.parse(url);
    final response = await http.put(uri, body: body, headers: { "token": token });
    if (response.statusCode == 200) {
      Toast.show("Comentario actualizado", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => EmpresaGeneral(comentario.id_emp, token)));
    } else {
      press = 0;
      Toast.show("Error al editar comentario", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Comentario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Calificacion",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildRatong(),
            const SizedBox(height: 60),
            const Text(
              "Comentario",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _descripcion(),
            const SizedBox(height: 20),
            _botonGuardar(),
          ],
        ),
      ),
    );
  }
}