import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  String _username = 'Usuario';

  String get username => _username;

  void loadUserData() {
    _username = 'Elias';
    notifyListeners();
  }
}
