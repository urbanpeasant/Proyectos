import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trabajo_flutter/home.dart';

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final List<String> imagenes = ['image1.jpg', 'image2.jpg', 'image3.jpg'];
  final List<String> frases = [
    'La vida es lo que pasa mientras reinstalas Android Studio por cuarta vez. - Sócrates',
    'Si crees que estás entendiendo Flutter, es que algo falla.- Aspasia',
    'Pedir a Javi que te cambie un examen por un trabajo es mala idea. - Confucio',
    'La vida es corta, programa un módulo de Odoo para hacerla larga. - Tales de Mileto',
    'La felicidad está hecha de pequeñas cosas. Odoo no es una de ellas. - Pitágoras',
    'La felicidad es lanzar main.dart y que no pete el emulador. Aristóteles- ',
    'Elige un trabajo que te guste y también te joderá perder un tercio de tu vida en él. - Platón',
    'El dinero no da la felicidad. Que no te lance errores Android Studio sí. - Heráclito',
    'Ser optimista significa pensar en Odoo sin deprimirse. - Sofistas ',
    'Leer la rúbrica del Notion con detenimiento antes de lanzarte a escribir código te ahorrará dolor y sufrimiento futuro. - Alcibiades '
  ];

  int numeroAleatorioImagen = Random().nextInt(3);
  int numeroAleatorioFrase = Random().nextInt(10);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/${imagenes[numeroAleatorioImagen]}'),
            SizedBox(height: 20),
            Text(
              frases[numeroAleatorioFrase],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
