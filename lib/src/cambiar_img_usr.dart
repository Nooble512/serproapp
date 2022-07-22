// ignore_for_file: use_build_context_synchronously, import_of_legacy_library_into_null_safe, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/src/datos_usuario.dart';
import 'package:serproapp/src/inicio.dart';
import 'package:toast/toast.dart' show Toast;

class CambiarImgUsr extends StatefulWidget {
  String token;
  CambiarImgUsr(this.token, {Key key}) : super(key: key) ;

  @override
  // ignore: no_logic_in_create_state
  State<CambiarImgUsr> createState() => _CambiarImgUsrState(token);
}

class _CambiarImgUsrState extends State<CambiarImgUsr> {
  String token;
  _CambiarImgUsrState(this.token);

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
  

  // ignore: non_constant_identifier_names
  void _subir_imagen() async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${UrlApi().url}/api/img/usuario'));
      request.headers['token'] = token;
      request.files.add(await http.MultipartFile.fromPath('img', _image.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        Toast.show("Imagen subida correctamente", context, duration: Toast.LENGTH_LONG);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio(token)));
        Navigator.push(context, MaterialPageRoute(builder: (context) => DatosUsuario(token)));
      } else {
        Toast.show("Error al subir la imagen", context, duration: Toast.LENGTH_LONG);
      }
    } catch (e) {
      Toast.show("Error al subir la imagen", context, duration: Toast.LENGTH_LONG);
    }
  }

  int subir = 0;

  Widget _botonSubir() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          if (subir == 0) {
            subir = 1;
            Toast.show("Subiendo imagen", context, duration: Toast.LENGTH_LONG);
            _subir_imagen();
          } else {
            Toast.show("Ya se esta subiendo la imagen", context, duration: Toast.LENGTH_LONG);
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
        title: const Text("Cambiar logo"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
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