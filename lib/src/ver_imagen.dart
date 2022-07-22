

import 'package:flutter/material.dart';

class VerImagen extends StatefulWidget {
  String url;
  VerImagen(this.url, {Key key}) : super(key: key);

  @override
  State<VerImagen> createState() => _VerImagenState(url);
}

class _VerImagenState extends State<VerImagen> {
  String url;
  _VerImagenState(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Stack(
            children: [
              Hero(
                tag: 'img', 
                child: Image.network(url),
              )
            ],
          ),
        ),
      ),
    );
  }
}