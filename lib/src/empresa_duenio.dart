// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:serproapp/model/Cupon.dart';
import 'package:serproapp/model/EmpresaDuenioModel.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/model/Imagenes.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/src/cambiar_logo_empresa.dart';
import 'package:serproapp/src/editar_empresa.dart';
import 'package:serproapp/src/nueva_imagen_empresa.dart';
import 'package:serproapp/src/nuevo_cupon.dart';

class EmpresaDuenio extends StatefulWidget {
  String token;
  EmpresaDuenio(this.token, {Key key}) : super(key: key);

  @override
  State<EmpresaDuenio> createState() => _EmpresaDuenioState(token);
}

class _EmpresaDuenioState extends State<EmpresaDuenio> {
  String token;
  _EmpresaDuenioState(this.token);

  Future<EmpresaDuenioModel> _empresa;
  Future<EmpresaDuenioModel> _getEmpresa() async{
    String url = '${UrlApi().url}/api/empresa';
    Map<String, String> header = {
      "token": token
    };
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: header);
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Imagenes> imagenes = [];
      for (var item in jsonData['imagenes']){
        imagenes.add(Imagenes(
          item['id'],
          item['url'],
          item['descripcion']
        ));
      }
      EmpresaDuenioModel empresa = EmpresaDuenioModel(
        jsonData["id"], 
        jsonData["nombre"], 
        jsonData["descripcion"], 
        jsonData["telefono"], 
        jsonData["latitud"], 
        jsonData["longitud"], 
        jsonData["img_logo"], 
        imagenes, 
      );
      return empresa;
    } else {
      throw Exception('Error');
    }
  }

  Future<List<Cupon>> _cupones;
  Future<List<Cupon>> _getCupones() async {
    String url = '${UrlApi().url}/api/empresa/cupon/cantidad';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: { "token": token });
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Cupon> cupones = [];
      for (var item in jsonData) {
        cupones.add(Cupon(
          item['id'],
          item['id_emp'],
          item['nombre'],
          item['descripcion'],
          item['cantidad'],
        ));
      }
      return cupones;
    } else {
      throw Exception('Error');
    }
  }

  // crear boton para edicion de datos
  Widget _crearBotonEditar(EmpresaDuenioModel empresa){
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditarEmpresa(token, empresa)));
        },
        child: const Text(
          'Editar datos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // Boton para editar imagen de perfil
  Widget _crearBotonEditarImagen(){
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CambiarLogoEmpresa(token)),);
        },
        child: const Text(
          'Editar logo de empresa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
  
  @override
  void initState() {
    _cupones = _getCupones();
    _empresa = _getEmpresa();
    super.initState();
  }

  Column _buildColumn(BuildContext context, EmpresaDuenioModel empresa) {
    final Map<MarkerId, Marker> markers = {};
    final Marker marker = Marker(markerId: const MarkerId('1'), position: LatLng(double.parse(empresa.latitud), double.parse(empresa.longitud)));
    markers[const MarkerId('0')] = marker;

    return Column(
      children: <Widget>[
        const SizedBox(height: 30),
        Image.network(
          empresa.img,
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 30),
        _crearBotonEditarImagen(),
        const Text("Nombre"),
        Text(
          empresa.nombre,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const Text("Descripción"),
        Text(
          empresa.descripcion, 
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const Text("Teléfono"),
        Text(
          empresa.telefono, 
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const Text("Imagenes"),
        SizedBox(
          width: double.infinity,
          height: 300,
          child: PageView(
            controller: PageController(
              viewportFraction: 0.5
            ),
            physics: const BouncingScrollPhysics(),
            children: _builImagenes(empresa.imagenes),
          ),
        ),
        const SizedBox(height: 30),
        _buildCupones(),
        SizedBox(
          height: 300,
          width: 450,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(empresa.latitud), double.parse(empresa.longitud)),
              zoom: 17,
            ),
            markers: markers.values.toSet(),
          ),
        ),
        const SizedBox(height: 100),
        _crearBotonEditar(empresa),
        const SizedBox(height: 100),

      ],
    );
  }

  Widget _buildCupones(){
    return FutureBuilder(
      future: _cupones,
      builder: (BuildContext context, AsyncSnapshot<List<Cupon>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              const Text("Cupones"),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: PageView(
                  controller: PageController(
                    viewportFraction: 0.5
                  ),
                  physics: const BouncingScrollPhysics(),
                  children: _builCountainerCup(snapshot.data),
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children: const[
              Text("Error"),
              SizedBox(height: 30),
            ],
          );
        }
        return Column(
          children: const [
            Center(
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 30),
          ],
        );
      }
    );
  }

  List<Widget> _builCountainerCup(List<Cupon> cupones){
    List<Widget> lista = [];
    for (var item in cupones) {
      lista.add(
        Container(
          margin: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(30),
          ),
          width: double.infinity,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Nombre",
                style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(item.nombre, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 30),
              const Text("Descripción",
                style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(item.descripcion, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 30),
              const Text("Cantidad",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(item.cantidad.toString(), style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }
    lista.add(
      Container(
        margin: const EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: FloatingActionButton(
            elevation: 10,
            backgroundColor: Colors.white,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NuevoCupon(token)));
            },
            child: const Icon(
              Icons.playlist_add_rounded,
              color: Colors.grey,
            ),
          )
        ),
      )
    );
    return lista;
  }

  List<Widget> _builImagenes(List<Imagenes> imagen){
    List<Widget> imagenes = [];
    for (var item in imagen){
      imagenes.add(
         // ignore: sized_box_for_whitespace
         Container(
            margin: const EdgeInsets.only(left: 30),
            child: Column(
              children: [
                Image.network(
                  item.url,
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                ),
                Text(item.descripcion),
              ],
            ),
         ),
      );
    }

    imagenes.add(
      Container(
        margin: const EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: FloatingActionButton(
            elevation: 10,
            backgroundColor: Colors.white,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NuevaImagenEmpresa(token)));
            },
            child: const Icon(
              Icons.add_photo_alternate,
              color: Colors.grey,
            ),
          )
        ),
      )
    );
    return imagenes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresa'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<EmpresaDuenioModel>(
            future: _empresa,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return _buildColumn(context, snapshot.data);
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}