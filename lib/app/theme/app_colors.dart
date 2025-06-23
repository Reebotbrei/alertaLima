import 'package:flutter/material.dart';

class AppColors {
  // 🎨 Colores base
  static const Color primary = Color.fromARGB(255, 5, 176, 67);    // Verde institucional
  static const Color background = Color.fromARGB(255, 255, 255, 255); // Blanco
  static const Color text = Color.fromARGB(255, 0, 0, 0);       // Negro
  static const Color muted = Color.fromARGB(255, 85, 85, 85);      // Gris oscuro para detalles

  // 🔘 Botones y componentes
  static const Color button = primary;
  static const Color buttonText = Colors.white;
  static const Color border = Color(0xFFCCCCCC);      // Bordes sutiles

  // 💡 Estados (opcional pero neutros)
  static const Color success = primary;
  static const Color error = Color(0xFFB00020);        // Rojo para errores
  static const Color disabled = Color(0xFFBDBDBD);     // Gris claro

  // 📏 Separadores
  static const Color divider = Color(0xFFE0E0E0);
}
