// ignore_for_file: file_names

import 'package:serproapp/model/Imagenes.dart';

class EmpresaDuenioModel{
  int id;
  String nombre;
  String descripcion;
  String telefono;
  String latitud;
  String longitud;
  String img;
  List<Imagenes> imagenes;

  EmpresaDuenioModel(this.id, this.nombre, this.descripcion, this.telefono, this.latitud, this.longitud, this.img, this.imagenes);

}