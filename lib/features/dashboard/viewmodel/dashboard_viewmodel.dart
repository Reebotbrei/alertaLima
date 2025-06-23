import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  String _username = 'Usuario';

  String get username => _username;

  // Esto puede simular una carga de usuario más adelante
  void loadUserData() {
    // Simulado: luego puedes reemplazar por llamada a Firebase
    _username = 'Elias';
    notifyListeners();
  }
}
