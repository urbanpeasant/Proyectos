import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class PantallaMultipleChoice extends StatefulWidget {
  @override
  _PantallaMultipleChoiceState createState() => _PantallaMultipleChoiceState();
}

class _PantallaMultipleChoiceState extends State<PantallaMultipleChoice> {
  final List<Map<String, dynamic>> preguntas = [
    {
      'pregunta': '¿Cuáles son los colores primarios?',
      'opciones': ['Rojo', 'Azul', 'Verde', 'Amarillo'],
      'respuestas': ['Rojo', 'Azul', 'Amarillo'],
      'respondida': false,
    },
    {
      'pregunta': '¿Cuáles son las partes de un átomo?',
      'opciones': ['Protones', 'Neutrones', 'Electrones', 'Núcleo'],
      'respuestas': ['Protones', 'Neutrones', 'Electrones', 'Núcleo'],
      'respondida': false,
    },
    {
      'pregunta': '¿Cuales de estas son asignaturas que da Javi?',
      'opciones': ['AD', 'PSP', 'Diseño de Interfaces', 'SGE'],
      'respuestas': ['AD', 'PSP', 'SGE'],
      'respondida': false,
    },
    {
      'pregunta': '¿Dónde quiere siempre ir el Migue en los recreos?',
      'opciones': ['Bocatas Manolo', 'A hablar con su novia por teléfono', 'Al museo del Prado', 'Al parque'],
      'respuestas': ['Bocatas Manolo', 'A hablar con su novia por teléfono'],
      'respondida': false,
    },
    {
      'pregunta': '¿Cuales son opciones viables en la informática?',
      'opciones': ['Mainframes', 'Almacenamiento en Nube', 'Guardar el trabajo en un usb', 'Guardar el trabajo en un CD'],
      'respuestas': ['Mainframes', 'Almacenamiento en Nube'],
      'respondida': false,
    },
  ];

  List<Map<String, dynamic>> preguntasRestantes = [];
  Map<String, dynamic>? preguntaActual;
  List<String> respuestasSeleccionadas = [];

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
      respuestasSeleccionadas.clear();
    });
  }

  void _cargarPreguntaAleatoria() {
    setState(() {
      if (preguntasRestantes.isNotEmpty) {
        preguntaActual = preguntasRestantes.removeAt(Random().nextInt(preguntasRestantes.length));
      } else {
        preguntaActual = null;
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
          _verificarRespuestas();
        }
      });
    });
  }

  void _verificarRespuestas() {
    setState(() {
      preguntaActual!['respondida'] = true;
    });

    List<String> respuestasCorrectas = preguntaActual!['respuestas'];

    // Verificar si las respuestas seleccionadas son correctas
    bool respuestasCorrectasSeleccionadas = true;
    for (String respuesta in respuestasSeleccionadas) {
      if (!respuestasCorrectas.contains(respuesta)) {
        respuestasCorrectasSeleccionadas = false;
        break;
      }
    }

    bool respuestaCorrecta = respuestasCorrectasSeleccionadas && respuestasSeleccionadas.length == respuestasCorrectas.length;

    _mostrarDialogoRespuesta(respuestaCorrecta);
  }

  void _mostrarDialogoRespuesta(bool respuestaCorrecta) {
    String titulo = respuestaCorrecta ? 'Respuesta Correcta' : 'Respuesta Incorrecta';
    String mensaje = respuestaCorrecta ? '¡Bien hecho!' : 'Inténtalo de nuevo.';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (preguntasRestantes.isEmpty) {
                  _mostrarDialogoTestCompletado();
                } else {
                  _cargarPreguntaAleatoria();
                  respuestasSeleccionadas.clear();
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
        title: Text('Test de Selección Múltiple'),
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
                return CheckboxListTile(
                  title: Text(opcion),
                  value: respuestasSeleccionadas.contains(opcion),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        respuestasSeleccionadas.add(opcion);
                      } else {
                        respuestasSeleccionadas.remove(opcion);
                      }
                    });
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: _verificarRespuestas,
              child: Text('Verificar'),
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
