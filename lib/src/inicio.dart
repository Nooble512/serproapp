// ignore_for_file: implementation_imports, must_be_immutable, no_logic_in_create_state, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:serproapp/model/EmpresaAll.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:serproapp/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/src/buscar_empresa.dart';
import 'package:serproapp/src/crear_empresa.dart';
import 'package:serproapp/src/datos_usuario.dart';
import 'package:serproapp/src/empresa_duenio.dart';
import 'package:serproapp/src/empresa_general.dart';
import 'package:serproapp/src/mis_cupones.dart';
import 'package:serproapp/src/ver_estadisticas.dart';
import 'package:toast/toast.dart';

class Inicio extends StatefulWidget {
  String token;

  Inicio(this.token, {Key key}) : super(key: key);
  @override
  State<Inicio> createState() => _InicioState(token);
}

class _InicioState extends State<Inicio> {
  String token;
  Future<Usuario> _user; 
  Future<List<EmpresaAll>> _empresas;

  Future<List<EmpresaAll>> _getEmpresa() async{
    final position = await Geolocator.getCurrentPosition();
    Map<String, String> body = {
      "lat": "${position.latitude}",
      "lng": "${position.longitude}"
    };
    print(body);
    String url = '${UrlApi().url}/api/empresa/all';
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
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
    } else {
      throw Exception('Error');
    }
  }

  Future<Usuario> _getUser() async{
    String url = "${UrlApi().url}/api/usuario";
    Map<String, String> header = {
      "token": token
    };
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: header);
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

  _InicioState(this.token);

  @override
  void initState(){
    _user = _getUser();
    _empresas = _getEmpresa( );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario>(
      future: _user,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData){
          return _scafold(snapshot.data);
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Inicio"),
            ),
            body: const Center(
              child: Text("Error"),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Inicio"),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _scafold(Usuario user){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: BuscarEmpresa(token));
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      drawer: _drawer(user),
      body: _center(),
    );
  }

  FutureBuilder _center(){
    return FutureBuilder<List<EmpresaAll>>(
      future: _empresas,
      builder: (context, AsyncSnapshot snapshot){
        if (snapshot.hasData){
          return ListView(
            children: _listEmpresas(snapshot.data),
          );
        } else if (snapshot.hasError){
          return const Center(
            child: Text("Error"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  List<Widget> _listEmpresas(List<EmpresaAll> data){
    List<Widget> empresas = [];
    for (var empresa in data){
      empresas.add(
        Card(
          child: ListTile(
            title: Text(empresa.nombre),
            subtitle: Text(empresa.descripcion),
            leading: Image.network(
              empresa.logo,
              height: 50,
              width: 50,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EmpresaGeneral(empresa.id, token)));
            },
          )
        ),
      );
    }

    return empresas;
  }

  Drawer _drawer(Usuario user){
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Image.network(
              user.imagen,
              height: 100,
              width: 100,
            ),
          ),
          ListTile(
            title: const Text("Cuenta"),
            subtitle: Text(user.nombre),
            trailing: const Icon(Icons.account_circle),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => DatosUsuario(token)));
            },
          ),
          ListTile(
            title: const Text("Mis cupones"),
            trailing: const Icon(Icons.confirmation_number),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => MisCupones(token)));
            },
          ),
          _empresaTale(user),
          ListTile(
            title: const Text("Cerrar Sesión"),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<EmpresaAll> _empresaUsuario;

  Future<EmpresaAll> _getEmpresaUsuario() async {
    String url = "${UrlApi().url}/api/empresa";
    Map<String, String> header = {
      "token": token
    };
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: header);
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      EmpresaAll empresa = EmpresaAll(
        jsonData["id"], 
        jsonData["nombre"], 
        jsonData["descripcion"], 
        jsonData["img_logo"],
      );
      return empresa;
    } else {
      throw Exception('Error');
    }
  }

  String cupon = "";

  void _canjear() async {
    String url = '${UrlApi().url}/api/empresa/cupon/canjear';
    Map<String, String> body = {
      'codigo': cupon,
    };
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, headers: { "token": token }, body: body);
    if (response.statusCode == 200){
      Toast.show('Cupon canjeado', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else if (response.statusCode == 400) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      Toast.show(jsonData["Error"], context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      Toast.show('Ocurrio un error', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  Widget _empresaTale(Usuario user){
    // Si el estado es 1, se obtengra los datos de la empresa de un get
    if (user.estado == 1) {
      _empresaUsuario = _getEmpresaUsuario();
      return FutureBuilder<EmpresaAll>(
        future: _empresaUsuario,
        builder: (context, AsyncSnapshot snapshot){
          if (snapshot.hasData){
            return Column(
              children: [
                ListTile(
                  title: const Text("Empresa"),
                  subtitle: Text(snapshot.data.nombre),
                  trailing: const Icon(Icons.business),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EmpresaDuenio(token)));
                  },
                ),
                ListTile(
                  title: const Text("Canjear cupon"),
                  trailing: const Icon(Icons.confirmation_number_outlined),
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        title: const Text("Cupon"),
                        content: TextField(
                          decoration: const InputDecoration(
                            hintText: "Cupon",
                          ),
                          onChanged: (value) {
                            cupon = value;
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cerrar")
                          ),
                          TextButton(
                            onPressed: () {
                              _canjear();
                            },
                            child: const Text("Canjear")
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Estadisticas'),
                  trailing: const Icon(Icons.insert_chart),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerEstadisticas(token)));
                  },
                )
              ],
            );
          } else if (snapshot.hasError){
            return ListTile(
              title: const Text("Empresa"),
              subtitle: const Text("No hay empresa"),
              trailing: const Icon(Icons.account_circle),
              onTap: () {
                // Agregar navegacion de paginna para editar usuario
              },
            );
          } else {
            return ListTile(
              title: const Text("Empresa"),
              subtitle: const Text("Cargando..."),
              trailing: const Icon(Icons.account_circle),
              onTap: () {
                // Agregar navegacion de paginna para editar usuario
              },
            );
          }
        }
      );
    } else {
      return ListTile(
        title: const Text("Crear empresa"),
        trailing: const Icon(Icons.add_business),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => CrearEmpresa(token)));
        },
      );
    }
  }
}