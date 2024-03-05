import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test de Verdadero/Falso',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaVF(),
    );
  }
}

class PantallaVF extends StatefulWidget {
  @override
  _PantallaVFState createState() => _PantallaVFState();
}

class _PantallaVFState extends State<PantallaVF> {
  final List<Map<String, dynamic>> preguntas = [
    {'pregunta': 'El sol es una estrella.', 'respuesta': true, 'respondida': false},
    {'pregunta': 'La Tierra es el cuarto planeta desde el Sol.', 'respuesta': false, 'respondida': false},
    {'pregunta': 'El agua hierve a 100 grados Celsius a nivel del mar.', 'respuesta': true, 'respondida': false},
    {'pregunta': 'La luna gira alrededor de la Tierra.', 'respuesta': true, 'respondida': false},
    {'pregunta': 'El hielo es más denso que el agua líquida.', 'respuesta': false, 'respondida': false},
    {'pregunta': 'Los mamíferos ponen huevos.', 'respuesta': false, 'respondida': false},
    {'pregunta': 'El agua es un compuesto químico.', 'respuesta': true, 'respondida': false},
    {'pregunta': 'El oxígeno es el gas más abundante en la atmósfera de la Tierra.', 'respuesta': false, 'respondida': false},
    {'pregunta': 'La velocidad de la luz es constante en el vacío.', 'respuesta': true, 'respondida': false},
    {'pregunta': 'El corazón humano tiene cuatro cámaras.', 'respuesta': false, 'respondida': false},
  ];

  List<Map<String, dynamic>> preguntasRestantes = [];
  Map<String, dynamic>? preguntaActual;

  Timer? _timer;
  int _countdown = 30;

  @override
  void initState() {
    super.initState();
    _resetTest();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTest() {
    setState(() {
      preguntasRestantes.clear();
      preguntasRestantes.addAll(preguntas);
      _cargarPreguntaAleatoria();
    });
  }

  void _cargarPreguntaAleatoria() {
    setState(() {
      if (preguntasRestantes.isNotEmpty) {
        preguntaActual = preguntasRestantes.removeAt(Random().nextInt(preguntasRestantes.length));
      } else {
        preguntaActual = null; // Indicar que se han contestado todas las preguntas
      }
    });

    // Reiniciar el temporizador al cargar una nueva pregunta
    _countdown = 30;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          _mostrarDialogoRespuesta('Tiempo Agotado');
        }
      });
    });
  }

  void _verificarRespuesta(bool respuestaSeleccionada) {
    setState(() {
      preguntaActual!['respondida'] = true;
    });

    if (respuestaSeleccionada == preguntaActual!['respuesta']) {
      _timer?.cancel();
      _mostrarDialogoRespuesta('Respuesta Correcta');
    } else {
      _timer?.cancel();
      _mostrarDialogoRespuesta('Respuesta Incorrecta');
    }
  }

  void _mostrarDialogoRespuesta(String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(titulo == 'Tiempo Agotado' ? 'Se acabó el tiempo. La respuesta es ${preguntaActual!['respuesta'] ? 'Verdadero' : 'Falso'}.' : 'La respuesta es ${preguntaActual!['respuesta'] ? 'Verdadero' : 'Falso'}.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (preguntasRestantes.isEmpty) {
                  _mostrarDialogoTestCompletado();
                } else {
                  _cargarPreguntaAleatoria();
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoTestCompletado() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Test Completado'),
          content: Text('¡Has respondido todas las preguntas!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTest();
              },
              child: Text('Reiniciar Test'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test de Verdadero/Falso'),
      ),
      body: Center(
        child: preguntaActual == null
            ? ElevatedButton(
          onPressed: _resetTest,
          child: Text('Empezar Test'),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              preguntaActual!['pregunta'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _verificarRespuesta(true);
                  },
                  child: Text('Verdadero'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _verificarRespuesta(false);
                  },
                  child: Text('Falso'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Tiempo restante: $_countdown segundos',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
