import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:serproapp/model/Comentario.dart';
import 'package:serproapp/model/Empresa.dart';
import 'package:serproapp/model/Imagenes.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/model/UsuarioEmpresa.dart';
import 'package:serproapp/src/editat_comentario.dart';
import 'package:serproapp/src/nuevo_comentario.dart';
import 'package:serproapp/src/ver_comentarios.dart';
import 'package:serproapp/src/ver_imagen.dart';
import 'package:url_launcher/url_launcher.dart';

class EmpresaGeneral extends StatefulWidget {
  int idNegocio;
  String token;
  EmpresaGeneral(this.idNegocio, this.token, {Key key}) : super(key: key);

  @override
  State<EmpresaGeneral> createState() => _EmpresaGeneralState(idNegocio, token);
}

class _EmpresaGeneralState extends State<EmpresaGeneral> {
  int idNegocio;
  String token;
  _EmpresaGeneralState(this.idNegocio, this.token);
  Future<Empresa> futureEmpresa;
  Future<Empresa> _getEmpresa() async{
    String url = "${UrlApi().url}/api/empresa/$idNegocio";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
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
      UsuarioEmpresa usuario = UsuarioEmpresa(
        jsonData["usuario"]["nombre"], 
        jsonData["usuario"]["apellido"], 
        jsonData["usuario"]["correo"], 
        jsonData["usuario"]["imagen"], 
      );
      Empresa empresa = Empresa(
        jsonData["nombre"], 
        jsonData["descripcion"], 
        jsonData["telefono"], 
        jsonData["latitud"], 
        jsonData["longitud"], 
        jsonData["img_logo"], 
        imagenes, 
        usuario, 
      );
      return empresa;
    } else {
      throw Exception('Error');
    }
  }

  Future<List<Comentario>> _comentario;
  Future<List<Comentario>> _getComentario() async{
    String url = "${UrlApi().url}/api/empresa/comentarios";
    Map<String, String> body = { "id_emp": '$idNegocio' };
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, body: body, headers: { "token":token });
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Comentario> comentarios = [];
      for (var item in jsonData){
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

  Future<Comentario> _comenXD;
  Future<Comentario> _getComenXD() async {
    String url = "${UrlApi().url}/api/empresa/comentario";
    Map<String, String> body = { "id_emp": '$idNegocio' };
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, body: body, headers: { "token":token });
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['Estatus'] == 1){
        Comentario comentario = Comentario(
          jsonData["id"], 
          jsonData["id_usu"], 
          jsonData["id_emp"], 
          jsonData["calificacion"], 
          jsonData["descripcion"],
          jsonData["nombre"],
          jsonData["apellido"],
          jsonData["imagen"],
          jsonData["correo"]
        );
        return comentario;
      } else {
        Comentario comentario = Comentario(0, 0, 0, 0, "0", "0", "0", "0", "0");
        return comentario;
      }
    } else {
      throw Exception('Error');
    }
  }

  void _interaccionEmp() {
    String url = "${UrlApi().url}/api/interaccion/insertar/empresa";
    Map<String, String> body = { 'id_emp':'$idNegocio' };
    Uri uri = Uri.parse(url);
    http.post(uri, body: body, headers: { "token":token });
  }

  void _interaccionLlamada(){
    String url = "${UrlApi().url}/api/interaccion/insertar/telefono";
    Map<String, String> body = { 'id_emp':idNegocio.toString() };
    Uri uri = Uri.parse(url);
    http.post(uri, body: body, headers: { "token":token });
  }

  @override
  void initState() {
    _interaccionEmp();
    _comenXD = _getComenXD();
    futureEmpresa = _getEmpresa();
    _comentario = _getComentario();
    super.initState();
  }

  Widget _telefono(String telefono){
    return SizedBox(
      width: MediaQuery.of(context).size.width-250,
      child: ListTile(
        leading: const Icon(Icons.phone),
        title: Text(telefono),
        onTap: () {
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: const Text("Llamar"),
              content: const Text("¿Desea llamar al negocio?"),
              actions: <Widget>[
                TextButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  child: const Text("Cancelar")
                ),
                TextButton(
                  onPressed: () async {
                    _interaccionLlamada();
                    FlutterPhoneDirectCaller.callNumber(telefono);
                    Navigator.pop(context);
                  },
                  child: const Text("Llamar")
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _cuerpo(Empresa empresa){
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Image.network(
              empresa.imglogo,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 30),
            Text(
              empresa.nombre,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              empresa.descripcion,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Teléfono",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _telefono(empresa.telefono),
            const SizedBox(height: 30),
            const Text(
              "Imagenes",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: PageView(
                controller: PageController(viewportFraction: 0.5),
                physics: const BouncingScrollPhysics(),
                children: _imagenes(empresa.imagenes),
              ),
            ),
            const Text(
              "Ubicación",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            _mapa(empresa),
            const SizedBox(height: 30),
            const Text(
              "Mi comentario",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _comentarioUsuario(),
            const SizedBox(height: 30),
            const Text(
              "Comentarios",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: FutureBuilder(
                future: _comentario,
                builder: (context, AsyncSnapshot<List<Comentario>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: _listComentarios(snapshot.data),
                    );
                  } else if (snapshot.hasError) {
                    return const Text("A ocurrido un error al cargar los comentarios");
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Propietario",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text("Nombre: ${empresa.usuario.nombre} ${empresa.usuario.apellido}"),
              subtitle: Text("Correo: ${empresa.usuario.correo}"),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(empresa.usuario.imagen),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _interaccionImagen() {
    String url = "${UrlApi().url}/api/interaccion/insertar/imagen";
    Map<String, String> body = { 'id_emp':idNegocio.toString() };
    Uri uri = Uri.parse(url);
    http.post(uri, body: body, headers: { "token":token });
  }

  List<Widget> _imagenes(List<Imagenes> img){
    List<Widget> imagenes = [];

    if (img.isNotEmpty){
      for (var item in img){
        imagenes.add(
          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Column(
              children: [
                GestureDetector(
                  child: Image.network(
                    item.url,
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                  onTap: (){
                    _interaccionImagen();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerImagen(item.url)));
                  },
                ),
                Text(item.descripcion),
              ],
            ),
          )
        );
      }
    } else {
      imagenes.add(
        Container(
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              "No hay imagenes",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        )
      );
    }
    return  imagenes;
  }

  void _interaccionMapa() {
    String url = "${UrlApi().url}/api/interaccion/insertar/mapa";
    Map<String, String> body = { 'id_emp':idNegocio.toString() };
    Uri uri = Uri.parse(url);
    http.post(uri, body: body, headers: { "token":token });
  }

  SizedBox _mapa(Empresa empresa){
    final Map<MarkerId, Marker> markers = {};
    final Marker marker = Marker(markerId: const MarkerId('1'), position: LatLng(double.parse(empresa.latitud), double.parse(empresa.longitud)));
    markers[const MarkerId('0')] = marker;

    return SizedBox(
      height: 300,
      width: 450,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(empresa.latitud), double.parse(empresa.longitud)),
          zoom: 15,
        ),
        markers: markers.values.toSet(),
        onTap: (LatLng position) {
          String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${empresa.latitud},${empresa.longitud}';
          Uri googleUri = Uri.parse(googleUrl);
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: const Text('¿Desea abrir el mapa?'),
              actions: <Widget>[
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async{
                    Navigator.pop(context);
                    if (await canLaunchUrl(googleUri)) {
                      _interaccionMapa();
                      await launchUrl(googleUri);
                    } else {
                      throw 'Could not launch $googleUrl';
                    }
                  }, 
                  child: const Text('Aceptar'),
                )
              ],
            ),
          );
          
        },
      ),
    );
  }

  List<Card> _listComentarios(List<Comentario> data){
    List<Card> comentarios = [];
    if (data.isNotEmpty){
      for (var item in data){
        comentarios.add(
          Card(
            child: ListTile(
              title: Text('${item.nombre} ${item.apellido}'),
              subtitle: Text(item.descripcion),
              trailing: Text("${item.calificacion.toString()}/5"),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item.imagen),
              ),
            ),
          )
        );
      }
      comentarios.add(
        Card(
          child: ListTile(
            title: const Text('Ver todos los comentarios'),
            leading: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VerComentarios(idNegocio, token)));
            },
          ),
        )
      );
    } else {
      comentarios.add(
        const Card(
          child: ListTile(
            title: Text("No hay comentarios"),
          ),
        )
      );
    }
    return comentarios;
  }

  FutureBuilder _comentarioUsuario(){
    return FutureBuilder (
      future: _comenXD,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.id != 0){
              return ListTile(
                title: Text("${snapshot.data.nombre} ${snapshot.data.apellido} - ${snapshot.data.calificacion}/5"),
                subtitle: Text(snapshot.data.descripcion),
                trailing: const Icon(Icons.edit),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data.imagen),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditarComentario(token, snapshot.data)));
                },
              );
            }
          else{
            return SizedBox(
              height: 100,
              width: 100,
              child: IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NuevoComentario(token, idNegocio)));
                }, 
                icon: const Icon(
                  Icons.add_circle_outline, 
                  color: Colors.blue, 
                  size: 75
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return const Text("A ocurrido un error al cargar los comentarios");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresa'),
      ),
      body: FutureBuilder<Empresa>(
        future: futureEmpresa,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData){
            return _cuerpo(snapshot.data);
          } else if (snapshot.hasError){
            return const Center(
              child: Text('Error'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}