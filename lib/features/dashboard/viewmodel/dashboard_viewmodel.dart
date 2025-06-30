import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  String _username = 'Usuario';

  String get username => _username;

  // Esto puede simular una carga de usuario más adelante
  void loadUserData() {
    
    _username = 'Elias';
    notifyListeners();
  }
}
