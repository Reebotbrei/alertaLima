import 'package:flutter/material.dart';

class AppColors {

  //  Colores base
  static const Color primary = Color.fromARGB(195, 32, 138, 71);    // Verde institucional
  static const Color background = Color.fromARGB(255, 255, 255, 255); // Blanco
  static const Color text = Color.fromARGB(255, 0, 0, 0);       // Negro
  static const Color muted = Color.fromARGB(255, 85, 85, 85);      // Gris oscuro para detalles

  //  Botones y componentes
  static const Color button = Color.fromARGB(195, 32, 138, 71);
  static const Color buttonText = Colors.white;
  static const Color border = Color(0xFFCCCCCC);      // Bordes sutiles

  //  Estados (opcional pero neutros)
  static const Color success = primary;
  static const Color error = Color.fromARGB(255, 176, 0, 32);        // Rojo para errores
  static const Color disabled = Color.fromARGB(251, 189, 189, 189);     // Gris claro

  //  Separadores
  static const Color divider = Color.fromARGB(255, 224, 224, 224);
}
