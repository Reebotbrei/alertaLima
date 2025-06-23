import 'package:flutter/material.dart';
import 'app/theme/app_theme.dart';
import 'features/sos/view/sos_screen.dart'; // Primera pantalla

void main() {
  runApp(const AlertaLimaApp());
}

class AlertaLimaApp extends StatelessWidget {
  const AlertaLimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerta Lima',
      theme: AppTheme.lightTheme,
      home: const SOSScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
