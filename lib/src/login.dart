// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/model/Url_Api.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';
import 'package:serproapp/src/singin.dart';
import 'package:serproapp/src/inicio.dart';

class Login extends StatefulWidget{
  const Login({Key key}) : super(key: key);


  @override
  _Login createState() => _Login();
}

String email = "";
String password = "";

Widget buildPassword(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Password',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0,2)
            )
          ]
        ),
        height: 60,
        child: TextField(
          obscureText: true,
          onChanged: (value) {
            password = value;
          },
          style: TextStyle(
            color: Colors.black87
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.lock,
              color: Color(0xff0b619c)
            ),
           hintText: 'Password',
           hintStyle: TextStyle(
             color: Colors.black38
           )
          ),
        ),
      )
    ],
  );
}

Widget buildEmail(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Email',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0,2)
            )
          ]
        ),
        height: 60,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (text){
            email = text;
          },
          style: TextStyle(
            color: Colors.black87
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.email,
              color: Color(0xff0b619c)
            ),
           hintText: 'Email',
           hintStyle: TextStyle(
             color: Colors.black38
           )
          ),
        ),
      )
    ],
  );
}

int onPressed = 0;

Widget buildLoginBtn(BuildContext context){
  return Container(
    padding: EdgeInsets.symmetric(vertical:25),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: (){
        if (onPressed == 0) {
          onPressed = 1;
          if(email == "" || password == ""){
            Toast.show("Los campos estan vacios", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            onPressed = 0;
          }else{
            singIn(email, password, context);
          }
        } else {
          Toast.show("Espere un momento", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      },
      child: const Text('SoyPro'),
    ),
  );
}

Widget buildSingInBtn(BuildContext context){
  return Container(
    padding: EdgeInsets.symmetric(vertical:25),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SingIn()));
      },
      child: const Text('SerPro'),
    ),
  );
}

singIn(String emai, String pass, BuildContext context) async{
  String url = "${UrlApi().url}/api/usuario/login/";
  Map<String, String> params = {
    "correo": emai,
    "contra": pass
  };

  Uri uri = Uri.parse(url);

  final response = await  http.post(uri, body:params);

  if (response.statusCode == 200){
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio(jsonData["token"])));
  } else if (response.statusCode == 400) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    Toast.show(jsonData["Error"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
  } else {
    Toast.show("Hay un error en el servidor", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
  }
  onPressed = 0;
}

Widget logica(BuildContext context){
  return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color(0x660b619c),
                      Color(0x990b619c),
                      Color(0xcc0b619c),
                      Color(0xff0b619c),
                    ]
                  )
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 120
                  ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 50,),
                    buildEmail(),
                    SizedBox(height: 20,),
                    buildPassword(),
                    buildLoginBtn(context),
                    buildSingInBtn(context),
                  ]
                )
                )
              )
            ],
          )
        )
      ),
    );
}

class _Login extends State<Login>{
  Future<bool> _gpsenabled;
  bool _isBooton;

  Future<bool> _getGpsEbable() async {
    bool gps = await Geolocator.isLocationServiceEnabled();
    return gps;
  }

  @override
  void initState() {
    _gpsenabled = _getGpsEbable();
    _isBooton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _gpsenabled,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return logica(context);
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Para usar la app es neserario que active el GPS",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Activar GPS'),
                      onPressed: () async {
                        if (_isBooton){
                          _isBooton = false;
                          Geolocator.openLocationSettings();
                          Future.delayed(const Duration(seconds: 5), () {
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
