import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../app/Objetitos/usuario.dart';
import 'package:intl/intl.dart';
import '../Model/profile_model.dart';

/// ViewModel para el manejo del estado y lógica de la pantalla de perfil de usuario.
class ProfileViewmodel extends ChangeNotifier {
  final ProfileRepository repository;

  // Estado del usuario
  Usuario _user = Usuario(
    id: '',
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
  late TextEditingController fechaNacimientoController;
  late TextEditingController direccionDetalladaController;

  // Estado de selección
  DateTime? _selectedFechaNacimiento;
  DateTime? get selectedFechaNacimiento => _selectedFechaNacimiento;
  set selectedFechaNacimiento(DateTime? date) {
    _selectedFechaNacimiento = date;
    fechaNacimientoController.text = date == null
        ? ''
        : DateFormat('dd/MM/yyyy').format(date);
    notifyListeners();
  }

  String? _selectedGenero;
  String? get selectedGenero => _selectedGenero;
  set selectedGenero(String? gender) {
    _selectedGenero = gender;
    notifyListeners();
  }

  String? _selectedDistrito;
  String? get selectedDistrito => _selectedDistrito;
  set selectedDistrito(String? value) {
    _selectedDistrito = value;
    notifyListeners();
    _cargarVecindarios();
  }

  String? _selectedVecindario;
  String? get selectedVecindario => _selectedVecindario;
  set selectedVecindario(String? value) {
    _selectedVecindario = value;
    notifyListeners();
  }

  // Listas para los dropdowns
  List<String> _distritos = [];
  List<String> get distritos => _distritos;
  set distritos(List<String> value) {
    _distritos = value.toSet().toList();
    if (_selectedDistrito != null && !_distritos.contains(_selectedDistrito)) {
      _selectedDistrito = null;
    }
    notifyListeners();
  }

  List<String> _vecindarios = [];
  List<String> get vecindarios => _vecindarios;
  set vecindarios(List<String> value) {
    _vecindarios = value.toSet().toList();
    if (_selectedVecindario != null && !_vecindarios.contains(_selectedVecindario)) {
      _selectedVecindario = null;
    }
    notifyListeners();
  }

  // Imagen temporal seleccionada
  File? _imageFile;
  File? get imageFile => _imageFile;

  // Constructor
  ProfileViewmodel(this.repository) {
    nombreCompletoController = TextEditingController();
    dniController = TextEditingController();
    numeroTelefonoController = TextEditingController();
    emailController = TextEditingController();
    fechaNacimientoController = TextEditingController();
    direccionDetalladaController = TextEditingController();
    _loadUserProfile();
    _cargarDistritos();
    _cargarVecindarios();
  }

  Future<void> _cargarDistritos() async {
    try {
      final lista = await repository.getDistritos();
      distritos = lista;
      if (lista.isNotEmpty && _selectedDistrito == null) {
        _selectedDistrito = lista.first;
      }
    } catch (e) {
      _errorMessage = "No se pudo cargar los distritos: $e";
      notifyListeners();
    }
  }

  Future<void> _cargarVecindarios() async {
    try {
      if (_selectedDistrito != null && _selectedDistrito!.isNotEmpty) {
        final lista = await repository.getVecindarios(_selectedDistrito!);
        vecindarios = lista;
        if (lista.isNotEmpty && _selectedVecindario == null) {
          _selectedVecindario = lista.first;
        }
      } else {
        vecindarios = [];
      }
    } catch (e) {
      _errorMessage = "No se pudo cargar los vecindarios: $e";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nombreCompletoController.dispose();
    dniController.dispose();
    numeroTelefonoController.dispose();
    emailController.dispose();
    fechaNacimientoController.dispose();
    direccionDetalladaController.dispose();
    super.dispose();
  }

  /// Carga el perfil del usuario desde Firestore
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
      final usuario = await repository.getUsuario(uid);
      if (usuario != null) {
        _user = usuario;
        nombreCompletoController.text = _user.nombre;
        emailController.text = _user.email;
        dniController.text = _user.dni?.toString() ?? '';
        numeroTelefonoController.text = _user.numeroTelefono?.toString() ?? '';
        _selectedFechaNacimiento = _user.fechaNacimiento;
        fechaNacimientoController.text = _user.fechaNacimiento == null
            ? ''
            : DateFormat('dd/MM/yyyy').format(_user.fechaNacimiento!);
        _selectedGenero = _user.genero;
        _selectedDistrito = _user.distrito;
        _selectedVecindario = _user.vecindario;
        direccionDetalladaController.text = _user.direccionDetallada ?? '';
      } else {
        _errorMessage =
            "Datos de perfil no encontrados en Firestore para el UID: $uid. Se inicializa un perfil básico.";
        _user = Usuario(
          id: uid,
          nombre: 'Usuario Nuevo',
          email: firebase_auth.FirebaseAuth.instance.currentUser?.email ??
              'nuevo_usuario@example.com',
          empadronado: false,
          distrito: null,
          direccionDetallada: null,
          fechaNacimiento: null,
          genero: null,
          dni: null,
          numeroTelefono: null,
          imageUrl: null,
        );
        nombreCompletoController.clear();
        dniController.clear();
        numeroTelefonoController.clear();
        emailController.text = _user.email;
        fechaNacimientoController.clear();
        direccionDetalladaController.clear();
        _selectedFechaNacimiento = null;
        _selectedGenero = null;
        _selectedDistrito = null;
        _selectedVecindario = null;
      }
    } catch (e) {
      _errorMessage = "Error al cargar el perfil: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Selector de fecha de nacimiento
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedFechaNacimiento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedFechaNacimiento) {
      selectedFechaNacimiento = pickedDate;
    }
  }

  /// Selector de imagen de perfil
  Future<void> updateImage(File image) async {
    _imageFile = image;
    notifyListeners();
  }

  /// Guarda los cambios del perfil del usuario
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
      // Validaciones básicas
      if (nombreCompletoController.text.trim().isEmpty) {
        _errorMessage = "El nombre completo es obligatorio.";
        _isLoading = false;
        notifyListeners();
        return;
      }
      if (_selectedFechaNacimiento == null) {
        _errorMessage = "La fecha de nacimiento es obligatoria.";
        _isLoading = false;
        notifyListeners();
        return;
      }
      if (_selectedGenero == null) {
        _errorMessage = "El género es obligatorio.";
        _isLoading = false;
        notifyListeners();
        return;
      }
      if (dniController.text.trim().isEmpty) {
        _errorMessage = "El número de identificación es obligatorio.";
        _isLoading = false;
        notifyListeners();
        return;
      }
      if (numeroTelefonoController.text.trim().isEmpty) {
        _errorMessage = "El número de teléfono es obligatorio.";
        _isLoading = false;
        notifyListeners();
        return;
      }
      if (_selectedDistrito == null) {
        _errorMessage = "El distrito es obligatorio.";
        _isLoading = false;
        notifyListeners();
        return;
      }
      bool usuarioActualizado =
          nombreCompletoController.text.trim().isNotEmpty &&
          _selectedFechaNacimiento != null &&
          _selectedGenero != null &&
          dniController.text.trim().isNotEmpty &&
          numeroTelefonoController.text.trim().isNotEmpty &&
          _selectedDistrito != null &&
          direccionDetalladaController.text.trim().isNotEmpty;

      String? imageUrl = _user.imageUrl;
      if (_imageFile != null) {
        // Subir imagen a Firebase Storage y obtener la URL
        imageUrl = await repository.uploadProfileImage(uid, _imageFile!);
      }

      final updatedUser = _user.copyWith(
        nombre: nombreCompletoController.text.trim(),
        email: emailController.text.trim(),
        dni: int.tryParse(dniController.text.trim()),
        numeroTelefono: int.tryParse(numeroTelefonoController.text.trim()),
        fechaNacimiento: _selectedFechaNacimiento,
        genero: _selectedGenero,
        distrito: _selectedDistrito,
        vecindario: _selectedVecindario,
        direccionDetallada: direccionDetalladaController.text.trim(),
        empadronado: usuarioActualizado,
        imageUrl: imageUrl,
      );
      await repository.saveUsuario(updatedUser);
      _user = updatedUser;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al actualizar el perfil: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
