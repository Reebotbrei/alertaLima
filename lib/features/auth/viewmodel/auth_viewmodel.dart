import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreControlador = TextEditingController();
  final confirmaContrasenaControlador = TextEditingController();
  bool isLoading = false;

  // Simulación de inicio de sesión
  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar(context, 'Completa todos los campos');
      return;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulación

    isLoading = false;
    notifyListeners();

    Navigator.pushReplacementNamed(context, '/dashboard'); // 👈 redirección
  }

  Future<void> fakeResetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnackbar(context, 'Ingresa tu correo');
      return;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulación

    isLoading = false;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instrucciones enviadas al correo')),
    );

    Navigator.pop(context); // Vuelve al login
  }

  // Simulación de registro
  Future<void> fakeRegister(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final nombre = nombreControlador.text.trim();
    final confirmaContrasena =  confirmaContrasenaControlador.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showSnackbar(context, 'Completa todos los campos');
      return;
    }
    if(password != confirmaContrasena){
        _showSnackbar(context, "Las contraseñas no coinciden");
      return;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simula llamada

    isLoading = false;
    notifyListeners();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Registro exitoso')));

    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
