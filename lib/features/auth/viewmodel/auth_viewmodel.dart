import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/auth/view/login_screen.dart';
import 'package:alerta_lima/features/dashboard/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreControlador = TextEditingController();
  final confirmaContrasenaControlador = TextEditingController();
  bool isLoading = false;

  // Ya tiene try
  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar(context, 'Completa todos los campos');
      return;
    }
    //el llamado para el ingreso y el recogo de datos se puede
    //hacer desde otra clase de conexion a base de datos, porque creo que estaremos
    //llamando varias veces desde varias partes
    try {
      isLoading = true;
      notifyListeners();

      UserCredential usuarioParaIngreso = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(usuarioParaIngreso.user!.uid)
          .get();

      if (!context.mounted) return;

      Usuario usuario = Usuario.fromFirestore(snapshot);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(usuario: usuario)),
      );
    } catch (e) {
      if (context.mounted) {
        _showSnackbar(context, "Correo o contraseña invalidos");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /*
  Future<void> ActualizarControsena(BuildContext context) async {
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

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instrucciones enviadas al correo')),
    );

    Navigator.pop(context); // Vuelve al login
  }
*/
  // Simulación de registro

  Future<void> registro(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final nombre = nombreControlador.text.trim();
    final confirmaContrasena = confirmaContrasenaControlador.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar(context, 'Completa todos los campos');
      return;
    }
    if (password.length < 6) {
      _showSnackbar(context, 'Contraseña debe tener minimo 6 caracteres');
      return;
    }
    if (password.compareTo(confirmaContrasena) != 0) {
      _showSnackbar(context, 'Las constraseñas no son iguales');
      return;
    }
    try {

      UserCredential usuario = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore.instance
          .collection('Usuario')
          .doc(usuario.user!.uid)
          .set({
            'DNI': null,
            'Distrito': null,
            'Email': email, 
            'Empadronado': false,
            'FechaNacimiento': null,
            'Nombre': nombre,
            'NumeroTelefono': null
            });
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Registro exitoso"),
          content: Text("Bienvenido a la cumunidad $nombre"),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
              icon: Text("Vamos allá"),
            ),
          ],
        ),
      );
    } catch (e) {
         if (context.mounted) {
        _showSnackbar(context, "Este correo ya está siendo utilizado");
      }
    }
  }
  void _showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}