import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa SystemNavigator

import 'pantalla_multiple_choice.dart';
import 'pantalla_single_choice.dart';
import 'pantalla_vf.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('¿Salir de la aplicación?'),
                    content: Text('¿Estás seguro de que deseas salir de la aplicación?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Usar SystemNavigator.pop() para salir completamente de la aplicación
                          SystemNavigator.pop();
                        },
                        child: Text('Salir'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Tests con Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40.0), // Espacio entre el título y el menú desplegable
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: DropdownButton<String>(
                hint: Text('Seleccionar tipo de pregunta'),
                onChanged: (String? value) {
                  switch (value) {
                    case 'multiple_choice':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantallaMultipleChoice()),
                      );
                      break;
                    case 'single_choice':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantallaSingleChoice()),
                      );
                      break;
                    case 'vf':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantallaVF()),
                      );
                      break;
                  }
                },
                items: [
                  DropdownMenuItem<String>(
                    value: 'multiple_choice',
                    child: Text('Preguntas de Selección Múltiple'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'single_choice',
                    child: Text('Preguntas de Selección Única'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'vf',
                    child: Text('Preguntas de Verdadero/Falso'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
