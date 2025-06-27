import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/dashboard/view/home_screen.dart';
import 'package:alerta_lima/features/auth/view/login_screen.dart';
import 'package:alerta_lima/main.dart'; 

class AuthViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreControlador = TextEditingController();
  final confirmaContrasenaControlador = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nombreControlador.dispose();
    confirmaContrasenaControlador.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('Completa todos los campos');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        _showSnackbar('Error: No se pudo obtener el usuario de Firebase.');
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Obtener el documento del usuario de Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Usuarios') 
          .doc(firebaseUser.uid)
          .get();

      Usuario usuario;
      if (snapshot.exists) {
        
        usuario = Usuario.fromFirestore(snapshot);
      } else {

        _showSnackbar("Datos de perfil no encontrados en Firestore. Creando un perfil básico...");
        usuario = Usuario(
          uid: firebaseUser.uid,
          nombre: firebaseUser.displayName ?? 'Usuario', // Usar displayName si Firebase lo tiene
          email: firebaseUser.email ?? email, // Usar email de Firebase Auth
          empadronado: false, // Valor por defecto
          // Los demás campos serán null o por defecto según tu modelo Usuario
        );
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(firebaseUser.uid)
            .set(usuario.toFirestore()); // Guarda el nuevo perfil
      }

      if (!context.mounted) { // Usamos el context directo si está disponible
        if (navigatorKey.currentContext == null || !navigatorKey.currentContext!.mounted) {
            ("Error de navegación: Contexto no disponible/montado.");
            _isLoading = false;
            notifyListeners();
            return;
        }
      }


      Navigator.pushReplacement(
        context.mounted ? context : navigatorKey.currentContext!, // Prioriza el context directo
        MaterialPageRoute(builder: (ctx) => HomeScreen(user: usuario)), // Pasa el objeto Usuario
      );

    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No existe una cuenta con este correo.';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta.';
          break;
        case 'invalid-email':
          message = 'El formato del correo electrónico es inválido.';
          break;
        case 'network-request-failed':
          message = 'Problema de conexión a internet. Intenta de nuevo.';
          break;
        default:
          message = 'Error al iniciar sesión: ${e.message}';
      }
      _showSnackbar(message);
    } catch (e) {
      _showSnackbar("Ocurrió un error inesperado al iniciar sesión.");
      print("Error en login: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> registro(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final nombre = nombreControlador.text.trim();
    final confirmaContrasena = confirmaContrasenaControlador.text.trim();

    if (email.isEmpty || password.isEmpty || nombre.isEmpty || confirmaContrasena.isEmpty) {
      _showSnackbar('Por favor, completa todos los campos.');
      return;
    }
    if (password.length < 6) {
      _showSnackbar('La contraseña debe tener al menos 6 caracteres.');
      return;
    }
    if (password != confirmaContrasena) {
      _showSnackbar('Las contraseñas no coinciden.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        _showSnackbar('Error: No se pudo crear el usuario de Firebase.');
        _isLoading = false;
        notifyListeners();
        return;
      }

      Usuario nuevoUsuario = Usuario(
        uid: firebaseUser.uid, 
        nombre: nombre,
        email: email,
        empadronado: false, 
        dni: null, 
        distrito: null, 
        imageUrl: null,
        fechaNacimiento: null, 
        genero: null, 
        numeroTelefono: null, 
      );

      await FirebaseFirestore.instance
          .collection('Usuarios') 
          .doc(firebaseUser.uid)
          .set(nuevoUsuario.toFirestore()); 

      if (!context.mounted) {
        if (navigatorKey.currentContext == null || !navigatorKey.currentContext!.mounted) {
            print("Error de diálogo: Contexto no disponible/montado.");
            _isLoading = false;
            notifyListeners();
            return;
        }
      }

      showDialog(
        context: context.mounted ? context : navigatorKey.currentContext!, // Prioriza context
        builder: (dialogContext) => AlertDialog(
          title: const Text("Registro exitoso"),
          content: Text("Bienvenido a la comunidad, $nombre!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo usando el context del builder
                // Asegúrate de que el contexto esté montado ANTES de navegar después del diálogo
                if (!context.mounted) {
                  if (navigatorKey.currentContext == null || !navigatorKey.currentContext!.mounted) {
                    print("Error de navegación: Contexto no disponible/montado después de diálogo.");
                    return;
                  }
                }
                // Navegar a HomeScreen después de cerrar el diálogo
                Navigator.pushReplacement(
                  context.mounted ? context : navigatorKey.currentContext!, // Prioriza context
                  MaterialPageRoute(builder: (c) => HomeScreen(user: nuevoUsuario)), // Pasa el usuario
                );
              },
              child: const Text("Vamos allá"),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Este correo ya está registrado.';
          break;
        case 'weak-password':
          message = 'La contraseña es demasiado débil.';
          break;
        case 'invalid-email':
          message = 'El formato del correo electrónico es inválido.';
          break;
        case 'network-request-failed':
          message = 'Problema de conexión a internet. Intenta de nuevo.';
          break;
        default:
          message = 'Error al registrar: ${e.message}';
      }
      _showSnackbar(message);
    } catch (e) {
      _showSnackbar("Ocurrió un error inesperado al registrar.");
      print("Error en registro: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para mostrar SnackBar (usando GlobalKey para mayor seguridad)
  void _showSnackbar(String msg) {
    if (navigatorKey.currentContext != null && navigatorKey.currentContext!.mounted) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(msg)));
    } else {
      print("Error: No se pudo mostrar Snackbar porque navigatorKey.currentContext no está montado."); // Se imprime en la consola si el context no está disponible
    }
  }

  // --- Lógica de Recuperar Contraseña ---
  Future<void> recuperarContrasena(BuildContext context) async { // Renombré de ActualizarControsena
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnackbar('Ingresa tu correo para recuperar contraseña.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackbar('Instrucciones para restablecer contraseña enviadas a tu correo.');
      if (context.mounted) { // Vuelve al login si el contexto está montado
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No existe una cuenta con este correo.';
      } else if (e.code == 'invalid-email') {
        message = 'El formato del correo electrónico es inválido.';
      } else if (e.code == 'network-request-failed') {
          message = 'Problema de conexión a internet. Intenta de nuevo.';
      } else {
        message = 'Error al enviar instrucciones: ${e.message}';
      }
      _showSnackbar(message);
    } catch (e) {
      _showSnackbar("Ocurrió un error inesperado.");
      print("Error en recuperarContrasena: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Función para cerrar sesión
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    // Limpiar los controladores
    emailController.clear();
    passwordController.clear();
    nombreControlador.clear();
    confirmaContrasenaControlador.clear();

    // Redirige al usuario a la pantalla de login y elimina todas las rutas anteriores
    if (navigatorKey.currentContext != null && navigatorKey.currentContext!.mounted) {
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Asegúrate de importar LoginScreen
        (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
      );
    }
  }
}