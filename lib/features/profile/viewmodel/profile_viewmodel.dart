import 'dart:io'; // Para File
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias para evitar conflicto de nombres
import 'package:firebase_storage/firebase_storage.dart'; // Para Firebase Storage
import '../../../app/Objetitos/usuario.dart'; // Importa tu clase Usuario

class ProfileViewmodel extends ChangeNotifier {
  // Propiedades del ViewModel
  Usuario _user = const Usuario(
    uid: '', // UID inicializado como vacío
    nombre: 'Invitado',
    email: 'invitado@example.com',
    empadronado: false,
  );
  Usuario get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Controladores para los campos de texto
  late TextEditingController nombreCompletoController;
  late TextEditingController dniController;
  late TextEditingController numeroTelefonoController; 
  late TextEditingController emailController;

  // Propiedades para la selección de fecha y género, ajustadas a los nombres del modelo Usuario
  DateTime? _selectedFechaNacimiento; 
  DateTime? get selectedFechaNacimiento => _selectedFechaNacimiento;
  set selectedFechaNacimiento(DateTime? date) {
    _selectedFechaNacimiento = date;
    notifyListeners();
  }

  String? _selectedGenero; // Antes _selectedGender
  String? get selectedGenero => _selectedGenero;
  set selectedGenero(String? gender) {
    _selectedGenero = gender;
    notifyListeners();
  }

  // Propiedad para la imagen temporalmente seleccionada
  File? _imageFile;
  File? get imageFile => _imageFile;

  // Constructor
  ProfileViewmodel() {
    nombreCompletoController = TextEditingController();
    dniController = TextEditingController();
    numeroTelefonoController = TextEditingController();
    emailController = TextEditingController();
    _loadUserProfile(); // Cargar el perfil al inicializar el ViewModel
  }

  @override
  void dispose() {
    nombreCompletoController.dispose();
    dniController.dispose();
    numeroTelefonoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Cargar el perfil del usuario desde Firestore
  Future<void> _loadUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String? uid = firebase_auth.FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        _errorMessage = "Usuario no autenticado. Por favor, inicia sesión.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();

      if (userDoc.exists) {
        _user = Usuario.fromFirestore(userDoc);
        // Inicializar controladores y propiedades con los datos del usuario
        nombreCompletoController.text = _user.nombre;
        emailController.text = _user.email;
        dniController.text = _user.dni?.toString() ?? '';
        numeroTelefonoController.text = _user.numeroTelefono ?? '';
        _selectedFechaNacimiento = _user.fechaNacimiento;
        _selectedGenero = _user.genero;

      } else {
        _errorMessage = "Datos de perfil no encontrados en Firestore para el UID: $uid. Se inicializa un perfil básico.";
        // Si el documento no existe, inicializa _user con datos básicos
        _user = Usuario(
          uid: uid,
          nombre: 'Usuario Nuevo',
          email: firebase_auth.FirebaseAuth.instance.currentUser?.email ?? 'nuevo_usuario@example.com',
          empadronado: false,
        );
      
        nombreCompletoController.clear();
        dniController.clear();
        numeroTelefonoController.clear();
        emailController.text = _user.email; // Establece el email del usuario de Auth
        _selectedFechaNacimiento = null;
        _selectedGenero = null;
      }
    } on FirebaseException catch (e) {
      _errorMessage = "Error de Firebase al cargar perfil: ${e.message}";
      ("Error Firebase al cargar perfil: $e");
    } catch (e) {
      _errorMessage = "Error al cargar el perfil: $e";
      ("Error general al cargar perfil: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Selector de fecha de nacimiento
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedFechaNacimiento ?? DateTime(2000), 
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedFechaNacimiento) {
      _selectedFechaNacimiento = pickedDate;
      notifyListeners();
    }
  }

  // Selector de imagen de perfil
  Future<void> updateImage(File image) async {
    _imageFile = image;
    notifyListeners();
  }

  // Guardar cambios del perfil
  Future<void> saveProfileChanges() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String? uid = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        _errorMessage = "Usuario no autenticado.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      String? newImageUrl = _user.imageUrl; // Mantener la URL existente por defecto

      // Si hay una nueva imagen seleccionada, subirla a Firebase Storage
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg');
        await storageRef.putFile(_imageFile!);
        newImageUrl = await storageRef.getDownloadURL();
      }

      // Crear un nuevo objeto Usuario con los datos actualizados de los controladores y propiedades
      final updatedUser = _user.copyWith(
        nombre: nombreCompletoController.text.trim(),
        email: emailController.text.trim(),
        dni: int.tryParse(dniController.text.trim()),
        numeroTelefono: numeroTelefonoController.text.trim(), // Guarda el número de teléfono
        fechaNacimiento: _selectedFechaNacimiento, // Guarda la fecha de nacimiento
        genero: _selectedGenero, // Guarda el género
        imageUrl: newImageUrl, // Asigna la nueva URL de la imagen

      );

      await FirebaseFirestore.instance.collection('Usuarios').doc(uid).update(updatedUser.toFirestore());

      _user = updatedUser; // Actualiza el _user localmente

      _errorMessage = null; // Limpiar cualquier mensaje de error anterior
      // Utiliza navigatorKey para mostrar el SnackBar de forma segura
      if (navigatorKey.currentContext != null && navigatorKey.currentContext!.mounted) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito!'), backgroundColor: Colors.green),
        );
      } else {
        ("Error: No se pudo mostrar SnackBar porque navigatorKey.currentContext no está montado.");
      }

    } on FirebaseException catch (e) {
      _errorMessage = "Error de Firebase al actualizar perfil: ${e.message}";
      ("Error Firebase al actualizar perfil: $e");
    } catch (e) {
      _errorMessage = "Error al actualizar el perfil: $e";
      ("Error general al actualizar perfil: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// Necesitas un GlobalKey para acceder al contexto del ScaffoldMessenger si no estás en un Widget.
// Añade esto en tu main.dart o en un archivo de utilidad global.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();