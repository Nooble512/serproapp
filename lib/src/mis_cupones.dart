import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serproapp/model/CuponUsuario.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:http/http.dart' as http;

class MisCupones extends StatefulWidget {
  String token;
  MisCupones(this.token, {Key key}) : super(key: key);

  @override
  State<MisCupones> createState() => _MisCuponesState(token);
}

class _MisCuponesState extends State<MisCupones> {
  String token;
  _MisCuponesState(this.token);

  Future<List<CuponUsuario>> _cupones;
  Future<List<CuponUsuario>> _getCupones() async {
    String url = "${UrlApi().url}/api/empresa/cupon/usuario";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: { 'token': token });
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<CuponUsuario> cupones = [];
      for (var item in jsonData) {
        CuponUsuario cupon = CuponUsuario(
          item['empresa'],
          item['img'],
          item['cupon'],
          item['descripcion'],
          item['codigo'],
        );
        cupones.add(cupon);
      }
      return cupones;
    } else {
      throw Exception('Error');
    }
  }

  @override
  void initState() {
    _cupones = _getCupones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cupones,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mis Cupones'),
            ),
            body: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${snapshot.data[index].empresa} - ${snapshot.data[index].cupon}'),
                  subtitle: Text(snapshot.data[index].descripcion),
                  leading: Image.network(snapshot.data[index].img),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        title: const Text("Cupon"),
                        content: Text("Codigo: ${snapshot.data[index].codigo}"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cerrar")
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        } else if (snapshot.hasError){
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mis Cupones'),
            ),
            body: const Center(
              child: Text('Error'),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}