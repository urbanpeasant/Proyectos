import 'package:flutter/material.dart';

class AppBarMenu extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Mi Aplicación'),
      actions: [
        DropdownButton<String>(
          icon: Icon(Icons.menu),
          underline: Container(),
          onChanged: (String? ruta) {
            if (ruta != null) {
              Navigator.pushNamed(context, ruta);
            }
          },
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              value: '/pantalla_inicio',
              child: Text('Página de Inicio'),
            ),
            DropdownMenuItem<String>(
              value: '/pregunta_vf',
              child: Text('Pregunta Verdadero/Falso'),
            ),
            DropdownMenuItem<String>(
              value: '/pregunta_single_choice',
              child: Text('Pregunta de Selección Única'),
            ),
            DropdownMenuItem<String>(
              value: '/pregunta_multiple_choice',
              child: Text('Pregunta de Opción Múltiple'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
