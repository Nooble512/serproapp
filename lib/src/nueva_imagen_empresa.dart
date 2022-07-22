// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/src/empresa_duenio.dart';
import 'package:serproapp/src/inicio.dart';
import 'package:toast/toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class NuevaImagenEmpresa extends StatefulWidget {
  String token;
  NuevaImagenEmpresa(this.token, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<NuevaImagenEmpresa> createState() => _NuevaImagenEmpresaState(token);
}

class _NuevaImagenEmpresaState extends State<NuevaImagenEmpresa> {
  String token;
  _NuevaImagenEmpresaState(this.token);

  File _image;
  final picker = ImagePicker();

  Future selImagen() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
          cortar(File(pickedFile.path));
      }else{
        Toast.show("No selecciono ninguna imagen", context, duration: Toast.LENGTH_LONG);
      }
    });
  }

  cortar(piked) async {
    CroppedFile cortado = await ImageCropper().cropImage(
      sourcePath: piked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 60
    );
    setState(() {
      if (cortado != null) {
          _image = File(cortado.path);
      } else {
        Toast.show("No selecciono ninguna imagen", context, duration: Toast.LENGTH_LONG);
      }
    });
  }

  void _subir_imagen(String descripcion) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${UrlApi().url}/api/img'));
      request.headers['token'] = token;
      request.fields['des'] = descripcion;
      request.files.add(await http.MultipartFile.fromPath('img', _image.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        Toast.show("Imagen subida correctamente", context, duration: Toast.LENGTH_LONG);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio(token)));
        Navigator.push(context, MaterialPageRoute(builder: (context) => EmpresaDuenio(token)));
      } else {
        Toast.show("Error al subir la imagen", context, duration: Toast.LENGTH_LONG);
      }
    } catch (e) {
      Toast.show("Error al subir la imagen", context, duration: Toast.LENGTH_LONG);
    }
  }

  String descripcion = "";

  // Widget para descripcion de la imagen
  Widget _descripcion() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextField(
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: "Descripcion",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          descripcion = value;
        },
      ),
    );
  }

  int subir = 0;

  // Widget boton para subir imagen
  Widget _botonSubir() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          if (descripcion == ""){
            Toast.show("No se ingreso ninguna descripcion", context, duration: Toast.LENGTH_LONG);
          } else {
            if (subir == 0) {
              subir = 1;
              Toast.show("Subiendo imagen", context, duration: Toast.LENGTH_LONG);
              _subir_imagen(descripcion);
            }else {
              Toast.show("Ya se esta subiendo la imagen", context, duration: Toast.LENGTH_LONG);
            }
          }
        },
        child: const Text("Subir imagen"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Imagen'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _descripcion(),
                ElevatedButton(
                  onPressed: (){
                    selImagen();
                  }, 
                  child: const Text('Selecionar Imagen'),
                ),
                const SizedBox(height: 30),
                _image == null ? const Center() : Image.file(_image),
                const SizedBox(height: 30),
                _botonSubir(),
              ]),
          ),
        ],
      ),
    );
  }
}