// ignore_for_file: implementation_imports, import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:serproapp/model/Url_Api.dart';
import 'package:toast/toast.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key key}) : super(key: key);


  @override
  State<SingIn> createState() => _SingInState();
}

String nombre = "";
String apellido = "";
String email = "";
String password = "";
String confirmPassword = "";

// Widget para el campo de nombre
Widget buildNombre() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Nombre',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: TextField(
          onChanged: (value) {
            nombre = value;
          },
          style: const TextStyle(
            color: Colors.black87,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.person,
              color: Color(0xff0b619c),
            ),
            hintText: 'Nombre',
          ),
        ),
      ),
    ],
  );
}

// Widget para el campo de apellido
Widget buildApellido() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Apellido',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: TextField(
          onChanged: (value) {
            apellido = value;
          },
          style: const TextStyle(
            color: Colors.black87,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.person,
              color: Color(0xff0b619c),
            ),
            hintText: 'Apellido',
          ),
        ),
      ),
    ],
  );
}

// Widget para el campo de email
Widget buildEmail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Email',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            email = value;
          },
          style: const TextStyle(
            color: Colors.black87,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.email,
              color: Color(0xff0b619c),
            ),
            hintText: 'Email',
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
          ),
        ),
      ),
    ],
  );
}

// Widget para el campo de password
Widget buildPassword() {
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
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: TextField(
          obscureText: true,
          onChanged: (value) {
            password = value;
          },
          style: const TextStyle(
            color: Colors.black87,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.lock,
              color: Color(0xff0b619c),
            ),
            hintText: 'Password',
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
          ),
        ),
      ),
    ],
  );
}

// Widget para el campo de confirmar password
Widget buildConfirmPassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Confirmar Password',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: TextField(
          obscureText: true,
          onChanged: (value) {
            confirmPassword = value;
          },
          style: const TextStyle(
            color: Colors.black87,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.lock,
              color: Color(0xff0b619c),
            ),
            hintText: 'Confirmar Password',
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
          ),
        ),
      ),
    ],
  );
}

int onPressed = 0;

// widget para el boton de registro
Widget buildSingUpBtn(BuildContext context){
  return Container(
    padding: const EdgeInsets.symmetric(vertical:25),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: (){
        if(onPressed == 0){
          onPressed = 1;
          if(email == "" || password == "" || confirmPassword == "" || nombre == "" || apellido == ""){
            Toast.show("Los campos estan vacios", context, duration: Toast.LENGTH_LONG);
            onPressed = 0;
          }else if (password != confirmPassword){
            Toast.show("Las contraseñas no coinciden", context, duration: Toast.LENGTH_LONG);
            onPressed = 0;
          } else{
            singup(nombre, apellido, email, password, confirmPassword, context);
          }
        } else {
          Toast.show("Espere un momento", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      },
      child: const Text('SerPro'),
    ),
  );
}

// boton de regresar
Widget buildBackBtn(BuildContext context){
  return Container(
    padding: const EdgeInsets.symmetric(vertical:25),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: (){
        Navigator.pop(context);
      },
      child: const Text('Regresar'),
    ),
  );
}

// funcion para crear el registro de usuario
singup(String nombre, String apellido, String email, String password, String confirmPassword, BuildContext context) async {
  String url = "${UrlApi().url}/api/usuario";
  Map<String, String> body = {
    "nombre": nombre,
    "apellido": apellido,
    "correo": email,
    "contra": password,
    "contrados": confirmPassword,
  };

  Uri uri = Uri.parse(url);

  final response = await http.post(uri, body: body);
  if (response.statusCode == 200) {
    Toast.show("Usuario creado", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    Navigator.of(context).pop();
  } else if (response.statusCode == 400) {
    final jsonData = json.decode(utf8.decode(response.bodyBytes));
    Toast.show(jsonData["Error"], context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  } else {
    Toast.show("Error de conexion", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
  onPressed = 0;
}

class _SingInState extends State<SingIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x660b619c),
                      Color(0x990b619c),
                      Color(0xcc0b619c),
                      Color(0xff0b619c),
                    ]
                  )
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 120
                  ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Crear usuario',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 50,),
                    buildNombre(),
                    const SizedBox(height: 20,),
                    buildApellido(),
                    const SizedBox(height: 20,),
                    buildEmail(),
                    const SizedBox(height: 20,),
                    buildPassword(),
                    const SizedBox(height: 20,),
                    buildConfirmPassword(),
                    const SizedBox(height: 20,),
                    buildSingUpBtn(context),
                    buildBackBtn(context),
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
}