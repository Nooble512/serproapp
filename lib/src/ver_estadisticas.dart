// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serproapp/model/Estadistica.dart';
import 'package:serproapp/model/Url_Api.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as elements;
import 'package:charts_flutter/src/text_style.dart' as styles;
import 'dart:math';

class VerEstadisticas extends StatefulWidget {
  String token;
  VerEstadisticas(this.token, {Key key}) : super(key: key);

  @override
  State<VerEstadisticas> createState() => _VerEstadisticasState(token);
}

class _VerEstadisticasState extends State<VerEstadisticas> {
  String token;
  _VerEstadisticasState(this.token);

  static String pointerAmount;
  static String pointerDay;

  static String pointerAmount2;
  static String pointerDay2;

  static String pointerAmount3;
  static String pointerDay3;

  static String pointerAmount4;
  static String pointerDay4;

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
            child: charts.LineChart(
              series,
              selectionModels: [
                charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model){
                    if (model.hasDatumSelection){
                      pointerAmount  = model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index)
                      .toStringAsFixed(2);
                      pointerDay = model.selectedSeries[0]
                      .domainFn(model.selectedDatum[0].index)
                      .toString();
                    }
                  }
                )
              ],
              behaviors: [
                charts.LinePointHighlighter(
                  symbolRenderer: MySymbolRender(),
                ),
              ],
            ),
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
            child: charts.LineChart(
              series,
              selectionModels: [
                charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model){
                    if (model.hasDatumSelection){
                      pointerAmount2  = model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index)
                      .toStringAsFixed(2);
                      pointerDay2 = model.selectedSeries[0]
                      .domainFn(model.selectedDatum[0].index)
                      .toString();
                    }
                  }
                )
              ],
              behaviors: [
                charts.LinePointHighlighter(
                  symbolRenderer: MySymbolRender2(),
                ),
              ],
            ),
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
            child: charts.LineChart(
              series,
              selectionModels: [
                charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model){
                    if (model.hasDatumSelection){
                      pointerAmount3  = model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index)
                      .toStringAsFixed(2);
                      pointerDay3 = model.selectedSeries[0]
                      .domainFn(model.selectedDatum[0].index)
                      .toString();
                    }
                  }
                )
              ],
              behaviors: [
                charts.LinePointHighlighter(
                  symbolRenderer: MySymbolRender3(),
                ),
              ],
            ),
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
            child: charts.LineChart(
              series,
              selectionModels: [
                charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model){
                    if (model.hasDatumSelection){
                      pointerAmount4  = model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index)
                      .toStringAsFixed(2);
                      pointerDay4 = model.selectedSeries[0]
                      .domainFn(model.selectedDatum[0].index)
                      .toString();
                    }
                  }
                )
              ],
              behaviors: [
                charts.LinePointHighlighter(
                  symbolRenderer: MySymbolRender4(),
                ),
              ],
            ),
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

class MySymbolRender extends charts.CircleSymbolRenderer{
  @override
  void paint(
    charts.ChartCanvas canvas, 
    Rectangle<num> bounds, 
    {
      List<int> dashPattern, 
      charts.Color fillColor, 
      charts.FillPatternType fillPattern,
      charts.Color strokeColor, 
      double strokeWidthPx
    }) {
    // TODO: implement paint
    super.paint(
      canvas, 
      bounds, 
      dashPattern: dashPattern, 
      fillColor: fillColor, 
      fillPattern: fillPattern, 
      strokeColor: strokeColor, 
      strokeWidthPx: strokeWidthPx
    );

    canvas.drawRect(
      Rectangle(
        bounds.left - 25, 
        bounds.top - 30, 
        bounds.width + 48, 
        bounds.height + 18,
      ),
      fill: charts.ColorUtil.fromDartColor(Colors.grey),
      stroke: charts.ColorUtil.fromDartColor(Colors.green),
      strokeWidthPx: 2
    );

    var myStyle = styles.TextStyle();
    myStyle.fontSize = 10;

    canvas.drawText(
      elements.TextElement(
        'Dia ${_VerEstadisticasState.pointerDay} \n${_VerEstadisticasState.pointerAmount}',
        style: myStyle
      ), 
      (bounds.left -20).round() , 
      (bounds.top - 26).round()
    );
  }
}

class MySymbolRender2 extends charts.CircleSymbolRenderer{
  @override
  void paint(
    charts.ChartCanvas canvas, 
    Rectangle<num> bounds, 
    {
      List<int> dashPattern, 
      charts.Color fillColor, 
      charts.FillPatternType fillPattern,
      charts.Color strokeColor, 
      double strokeWidthPx
    }
  ) {

    super.paint(
      canvas, 
      bounds, 
      dashPattern: dashPattern, 
      fillColor: fillColor, 
      fillPattern: fillPattern, 
      strokeColor: strokeColor, 
      strokeWidthPx: strokeWidthPx
    );

    canvas.drawRect(
      Rectangle(
        bounds.left - 25, 
        bounds.top - 30, 
        bounds.width + 48, 
        bounds.height + 18,
      ),
      fill: charts.ColorUtil.fromDartColor(Colors.grey),
      stroke: charts.ColorUtil.fromDartColor(Colors.green),
      strokeWidthPx: 2
    );

    var myStyle = styles.TextStyle();
    myStyle.fontSize = 10;

    canvas.drawText(
      elements.TextElement(
        'Dia ${_VerEstadisticasState.pointerDay2} \n${_VerEstadisticasState.pointerAmount2}',
        style: myStyle
      ), 
      (bounds.left -20).round() , 
      (bounds.top - 26).round()
    );
  }
}

class MySymbolRender3 extends charts.CircleSymbolRenderer{
  @override
  void paint(
    charts.ChartCanvas canvas, 
    Rectangle<num> bounds, 
    {
      List<int> dashPattern, 
      charts.Color fillColor, 
      charts.FillPatternType fillPattern,
      charts.Color strokeColor, 
      double strokeWidthPx
    }
  ) {

    super.paint(
      canvas, 
      bounds, 
      dashPattern: dashPattern, 
      fillColor: fillColor, 
      fillPattern: fillPattern, 
      strokeColor: strokeColor, 
      strokeWidthPx: strokeWidthPx
    );

    canvas.drawRect(
      Rectangle(
        bounds.left - 25, 
        bounds.top - 30, 
        bounds.width + 48, 
        bounds.height + 18,
      ),
      fill: charts.ColorUtil.fromDartColor(Colors.grey),
      stroke: charts.ColorUtil.fromDartColor(Colors.green),
      strokeWidthPx: 2
    );

    var myStyle = styles.TextStyle();
    myStyle.fontSize = 10;

    canvas.drawText(
      elements.TextElement(
        'Dia ${_VerEstadisticasState.pointerDay3} \n${_VerEstadisticasState.pointerAmount3}',
        style: myStyle
      ), 
      (bounds.left -20).round() , 
      (bounds.top - 26).round()
    );
  }
}

class MySymbolRender4 extends charts.CircleSymbolRenderer{
  @override
  void paint(
    charts.ChartCanvas canvas, 
    Rectangle<num> bounds, 
    {
      List<int> dashPattern, 
      charts.Color fillColor, 
      charts.FillPatternType fillPattern,
      charts.Color strokeColor, 
      double strokeWidthPx
    }
  ) {

    super.paint(
      canvas, 
      bounds, 
      dashPattern: dashPattern, 
      fillColor: fillColor, 
      fillPattern: fillPattern, 
      strokeColor: strokeColor, 
      strokeWidthPx: strokeWidthPx
    );

    canvas.drawRect(
      Rectangle(
        bounds.left - 25, 
        bounds.top - 30, 
        bounds.width + 48, 
        bounds.height + 18,
      ),
      fill: charts.ColorUtil.fromDartColor(Colors.grey),
      stroke: charts.ColorUtil.fromDartColor(Colors.green),
      strokeWidthPx: 2
    );

    var myStyle = styles.TextStyle();
    myStyle.fontSize = 10;

    canvas.drawText(
      elements.TextElement(
        'Dia ${_VerEstadisticasState.pointerDay4} \n${_VerEstadisticasState.pointerAmount4}',
        style: myStyle
      ), 
      (bounds.left -20).round() , 
      (bounds.top - 26).round()
    );
  }
}