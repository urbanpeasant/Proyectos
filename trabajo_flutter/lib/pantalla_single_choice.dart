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
      title: 'Test de Selección Simple',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaSingleChoice(),
    );
  }
}

class PantallaSingleChoice extends StatefulWidget {
  @override
  _PantallaSingleChoiceState createState() => _PantallaSingleChoiceState();
}

class _PantallaSingleChoiceState extends State<PantallaSingleChoice> {
  final List<Map<String, dynamic>> preguntas = [
    {
      'pregunta': '¿Cuál es la capital de España?',
      'opciones': ['Londres', 'Madrid', 'París', 'Roma'],
      'respuesta': 'Madrid',
      'respondida': false,
    },
    {
      'pregunta': '¿Cuál es el planeta más grande del sistema solar?',
      'opciones': ['Tierra', 'Marte', 'Júpiter', 'Saturno'],
      'respuesta': 'Júpiter',
      'respondida': false,
    },
    {
      'pregunta': '¿Cuál es el metal más caro del mundo?',
      'opciones': ['Oro', 'Platino', 'Rodio', 'Iridio'],
      'respuesta': 'Rodio',
      'respondida': false,
    },
    {
      'pregunta': '¿Cuál es la mejor opción para que nos examine Javi?',
      'opciones': ['Exámenes', 'Trabajos', 'Intentar sobornarlo', 'Rezar'],
      'respuesta': 'Exámenes',
      'respondida': false,
    },
    {
      'pregunta': '¿Cuantos días de descanso va a tener Jose antes de las prácticas?',
      'opciones': ['Un mes', 'Una semana', 'Un día', 'Nada'],
      'respuesta': 'Nada',
      'respondida': false,
    },

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

  void _verificarRespuesta(String? respuestaSeleccionada) {
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
          content: Text(titulo == 'Tiempo Agotado' ? 'Se acabó el tiempo. La respuesta es ${preguntaActual!['respuesta']}.' : 'La respuesta es ${preguntaActual!['respuesta']}.'),
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
        title: Text('Test de Selección Simple'),
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
            Column(
              children: List.generate(preguntaActual!['opciones'].length, (index) {
                String opcion = preguntaActual!['opciones'][index];
                return RadioListTile(
                  title: Text(opcion),
                  value: opcion,
                  groupValue: null, // Aquí deberías establecer el valor seleccionado
                  onChanged: (value) {
                    _verificarRespuesta(value);
                  },
                );
              }),
            ),
            SizedBox(height: 10),
            Text(
              'Te quedan: $_countdown segundos!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
