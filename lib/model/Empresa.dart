// ignore_for_file: file_names

import 'package:serproapp/model/Imagenes.dart';
import 'package:serproapp/model/UsuarioEmpresa.dart';

class Empresa{
  String nombre;
  String descripcion;
  String telefono;
  String latitud;
  String longitud;
  String imglogo;
  List<Imagenes> imagenes;
  UsuarioEmpresa usuario;

  Empresa(this.nombre, this.descripcion, this.telefono, this.latitud, this.longitud, this.imglogo, this.imagenes, this.usuario);
}