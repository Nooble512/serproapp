// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serproapp/model/Estadistica.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class VerEstadisticas extends StatefulWidget {
  String token;
  VerEstadisticas(this.token, {Key key}) : super(key: key);

  @override
  State<VerEstadisticas> createState() => _VerEstadisticasState(token);
}

class _VerEstadisticasState extends State<VerEstadisticas> {
  String token;
  _VerEstadisticasState(this.token);

  Future<List<Estadistica>> _interaccionEmpresa;
  Future<List<Estadistica>> _getInteraccionEmpresa() async {
    String url = "${UrlApi().url}/api/interaccion/obtener/empresa";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: { 'token': token, });
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Estadistica> estadisticas = [];
      for (var item in jsonData){
        Estadistica estadistica = Estadistica(
          item['dia'],
          item['cantidad'],
        );
        estadisticas.add(estadistica);
      }
      return estadisticas;
    } else {
      throw Exception('Error');
    }
  }

  Future<List<Estadistica>> _interaccionTelefono;
  Future<List<Estadistica>> _getInteraccionTelefono() async {
    String url = "${UrlApi().url}/api/interaccion/obtener/telefono";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: { 'token': token, });
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Estadistica> estadisticas = [];
      for (var item in jsonData){
        Estadistica estadistica = Estadistica(
          item['dia'],
          item['cantidad'],
        );
        estadisticas.add(estadistica);
      }
      return estadisticas;
    } else {
      throw Exception('Error');
    }
  }

  Future<List<Estadistica>> _interaccionImagen;
  Future<List<Estadistica>> _getInteraccionImagen() async {
    String url = "${UrlApi().url}/api/interaccion/obtener/imagen";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: { 'token': token, });
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Estadistica> estadisticas = [];
      for (var item in jsonData){
        Estadistica estadistica = Estadistica(
          item['dia'],
          item['cantidad'],
        );
        estadisticas.add(estadistica);
      }
      return estadisticas;
    } else {
      throw Exception('Error');
    }
  }

  Future<List<Estadistica>> _interaccionMapa;
  Future<List<Estadistica>> _getInteraccionMapa() async {
    String url = "${UrlApi().url}/api/interaccion/obtener/mapa";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: { 'token': token, });
    if (response.statusCode == 200){
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Estadistica> estadisticas = [];
      for (var item in jsonData){
        Estadistica estadistica = Estadistica(
          item['dia'],
          item['cantidad'],
        );
        estadisticas.add(estadistica);
      }
      return estadisticas;
    } else {
      throw Exception('Error');
    }
  }
  
  @override
  void initState() {
    _interaccionEmpresa = _getInteraccionEmpresa();
    _interaccionTelefono = _getInteraccionTelefono();
    _interaccionImagen = _getInteraccionImagen();
    _interaccionMapa = _getInteraccionMapa();
    super.initState();
  }

  Widget _graficaInteraccionEmpresa(){
    return FutureBuilder(
      future: _interaccionEmpresa,
      builder: (BuildContext context, AsyncSnapshot<List<Estadistica>> snapshot) {
        if (snapshot.hasData){
          final data = snapshot.data;

          List<charts.Series<Estadistica, int>> series = [
            charts.Series<Estadistica, int>(
              id: 'Interaccion',
              domainFn: (datum, index) => datum.dia,
              measureFn: (datum, index) => datum.cantidad,
              data: data,
            )
          ];
          return SizedBox(
            height: 350,
            child: charts.LineChart(series),
          );
        } else if (snapshot.hasError){
          return const Text('Error');
        } 
        return const Center(
          child: CircularProgressIndicator(),
        );
        
      },
    );
  }

  Widget _graficaInteraccionTelefono(){
    return FutureBuilder(
      future: _interaccionTelefono,
      builder: (BuildContext context, AsyncSnapshot<List<Estadistica>> snapshot) {
        if (snapshot.hasData){
          final data = snapshot.data;

          List<charts.Series<Estadistica, int>> series = [
            charts.Series<Estadistica, int>(
              id: 'Interaccion',
              domainFn: (datum, index) => datum.dia,
              measureFn: (datum, index) => datum.cantidad,
              data: data,
            )
          ];
          return SizedBox(
            height: 350,
            child: charts.LineChart(series),
          );
        } else if (snapshot.hasError){
          return const Text('Error');
        } 
        return const Center(
          child: CircularProgressIndicator(),
        );
        
      },
    );
  }

  Widget _graficaInteraccionImagen(){
    return FutureBuilder(
      future: _interaccionImagen,
      builder: (BuildContext context, AsyncSnapshot<List<Estadistica>> snapshot) {
        if (snapshot.hasData){
          final data = snapshot.data;

          List<charts.Series<Estadistica, int>> series = [
            charts.Series<Estadistica, int>(
              id: 'Interaccion',
              domainFn: (datum, index) => datum.dia,
              measureFn: (datum, index) => datum.cantidad,
              data: data,
            )
          ];
          return SizedBox(
            height: 350,
            child: charts.LineChart(series),
          );
        } else if (snapshot.hasError){
          return const Text('Error');
        } 
        return const Center(
          child: CircularProgressIndicator(),
        );
        
      },
    );
  }

  Widget _graficaInteraccionMapa(){
    return FutureBuilder(
      future: _interaccionMapa,
      builder: (BuildContext context, AsyncSnapshot<List<Estadistica>> snapshot) {
        if (snapshot.hasData){
          final data = snapshot.data;

          List<charts.Series<Estadistica, int>> series = [
            charts.Series<Estadistica, int>(
              id: 'Interaccion',
              domainFn: (datum, index) => datum.dia,
              measureFn: (datum, index) => datum.cantidad,
              data: data,
            )
          ];
          return SizedBox(
            height: 350,
            child: charts.LineChart(series),
          );
        } else if (snapshot.hasError){
          return const Text('Error');
        } 
        return const Center(
          child: CircularProgressIndicator(),
        );
        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadisticas del mes'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const SizedBox(
                width: 350,
                child: Text(
                  'Interacciones con la empresa',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              _graficaInteraccionEmpresa(),
              const SizedBox(height: 50),
              const SizedBox(
                width: 350,
                child: Text(
                  'Interacciones con el telefono',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              _graficaInteraccionTelefono(),
              const SizedBox(height: 50),
              const SizedBox(
                width: 350,
                child: Text(
                  'Interacciones con las imagenes',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              _graficaInteraccionImagen(),
              const SizedBox(height: 50),
              const SizedBox(
                width: 350,
                child: Text(
                  'Interacciones con el mapa',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              _graficaInteraccionMapa(),
            ],
          ),
        ),
      ),
    );
  }
}