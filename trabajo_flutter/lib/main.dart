import 'package:flutter/material.dart';
import 'pantalla_inicio.dart';
import 'pantalla_vf.dart';
import 'pantalla_single_choice.dart';
import 'pantalla_multiple_choice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/pantalla_inicio',
      routes: {
        '/pantalla_inicio': (context) => PantallaInicio(),
        '/pregunta_vf': (context) => PantallaVF(),
        '/pregunta_single_choice': (context) => PantallaSingleChoice(),
        '/pregunta_multiple_choice': (context) => PantallaMultipleChoice(),
      },
    );
  }
}
