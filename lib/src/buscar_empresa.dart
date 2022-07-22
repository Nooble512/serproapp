import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:serproapp/model/EmpresaAll.dart';
import 'package:serproapp/model/Historial.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/src/empresa_general.dart';
import 'package:toast/toast.dart';

class BuscarEmpresa extends SearchDelegate<EmpresaAll>{
  String token;
  BuscarEmpresa(this.token);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      },  
      icon: const Icon(Icons.arrow_back),
    );
  }

  Future<List<EmpresaAll>> _empresas;
  Future<List<EmpresaAll>> _getEmpresa(String target) async {
    final position = await Geolocator.getCurrentPosition();
    String url = '${UrlApi().url}/api/empresa/search';
    Map<String, String> body = {
      "lat": "${position.latitude}",
      "lng": "${position.longitude}",
      "target": target
    };
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, body: body, headers: {"token": token});
    print('La respuesta es: ${response.statusCode}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print('El resultado es: $jsonData');
      List<EmpresaAll> empresas = [];
      for (var item in jsonData) {
        EmpresaAll empresa = EmpresaAll(
          item['id'],
          item['nombre'],
          item['descripcion'],
          item['img_logo'],
        );
        empresas.add(empresa);
      }
      return empresas;
    } else if (response.statusCode == 400) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      print('El resultado del estatus 400 es: $jsonData');
    }else {
      Exception('Error');
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    _empresas = _getEmpresa(query);
    return FutureBuilder(
      future: _empresas,
      builder: (BuildContext context, AsyncSnapshot<List<EmpresaAll>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.network(
                  snapshot.data[index].logo,
                  height: 50,
                  width: 50,
                ),
                title: Text(snapshot.data[index].nombre),
                subtitle: Text(snapshot.data[index].descripcion),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmpresaGeneral(snapshot.data[index].id, token)));
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
  
  Future<List<Historial>> _historial;
  Future<List<Historial>> _getHistorial() async{
    String url = '${UrlApi().url}/api/usuario/historial';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: {"token": token});
    if (response.statusCode == 200){
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      List<Historial> historial = [];
      for (var item in jsonData){
        Historial his = Historial(item['busqueda'], item['dia'], item['mes'], item['anio']);
        historial.add(his);
      }
      return historial;
    } else {
      throw Exception('Error');
    }
  }
  List<Historial> _filtro = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    _historial = _getHistorial();
    return FutureBuilder(
      future: _historial,
      builder: (context, AsyncSnapshot<List<Historial>> snapshot) {
        if (snapshot.hasData){
          _filtro = snapshot.data.where((element) => 
            element.busqueda.toLowerCase().contains(query.toLowerCase())
          ).toList();
          return ListView.builder(
            itemCount: _filtro.length,
            itemBuilder: (_, index){
              return ListTile(
                title: Text(_filtro[index].busqueda),
                leading: const Icon(Icons.history),
                onTap: () {
                  query = _filtro[index].busqueda;
                },
              );
            }
          );
        } else if (snapshot.hasError){
          return const Center(
            child: Text("Error"),
          );
        }
        return const  Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}