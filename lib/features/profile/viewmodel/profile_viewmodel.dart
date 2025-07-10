import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../app/Objetitos/usuario.dart';
import 'package:intl/intl.dart';

class ProfileViewmodel extends ChangeNotifier {
  // Propiedades del ViewModel
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
  late TextEditingController fechaNacimientoController; //
  late TextEditingController direccionDetalladaController; //

  // Propiedades para la selección de fecha y género, ajustadas a los nombres del modelo Usuario
  DateTime? _selectedFechaNacimiento;
  DateTime? get selectedFechaNacimiento => _selectedFechaNacimiento;
  set selectedFechaNacimiento(DateTime? date) {
    _selectedFechaNacimiento = date;
    fechaNacimientoController.text = date == null
        ? ''
        : DateFormat('dd/MM/yyyy').format(date);
    notifyListeners();
  }

  String? _selectedGenero; // Antes _selectedGender
  String? get selectedGenero => _selectedGenero;
  set selectedGenero(String? gender) {
    _selectedGenero = gender;
    notifyListeners();
  }

  // Propiedades para los dropdowns de dirección
  String? _selectedProvincia;
  String? get selectedProvincia => _selectedProvincia;
  set selectedProvincia(String? value) {
    _selectedProvincia = value;
    notifyListeners();
  }

  String? _selectedDistrito;
  String? get selectedDistrito => _selectedDistrito;
  set selectedDistrito(String? value) {
    _selectedDistrito = value;
    notifyListeners();
    _cargarVecindarios(); // Cargar vecindarios cada vez que cambia el distrito
  }

  String? _selectedVecindario;
  String? get selectedVecindario => _selectedVecindario;
  set selectedVecindario(String? value) {
    _selectedVecindario = value;
    notifyListeners();
  }

  // Listas de opciones para los dropdowns
  final List<String> provincias = ['LIMA'];

  // Lista de distritos para los dropdowns
  List<String> _distritos = [];
  List<String> get distritos => _distritos;
  set distritos(List<String> value) {
    // Elimina duplicados
    _distritos = value.toSet().toList();
    // Si el distrito seleccionado no está en la lista, lo resetea
    if (_selectedDistrito != null && !_distritos.contains(_selectedDistrito)) {
      _selectedDistrito = null;
    }
    notifyListeners();
  }

  // Lista de vecindarios para los dropdowns
  List<String> _vecindarios = [];
  List<String> get vecindarios => _vecindarios;
  set vecindarios(List<String> value) {
    _vecindarios = value.toSet().toList();
    // Si el vecindario seleccionado no está en la lista, lo resetea
    if (_selectedVecindario != null && !_vecindarios.contains(_selectedVecindario)) {
      _selectedVecindario = null;
    }
    notifyListeners();
  }

  //Llamar a la lista de distritos de Firebase
  Future<List<String>> getDistritosFromFirestore() async {
    List<String> distritos = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Distritos')
          .get();
      for (var doc in querySnapshot.docs) {
        distritos.add(doc.id); // El id del documento es el nombre del distrito
      }
    } catch (e) {
      debugPrint("Error al obtener distritos de Firestore: $e");
    }
    return distritos;
  }

  //Llamar a la lista de vecindarios de Firebase
  Future<List<String>> getVecindariosFromFirestore() async {
    List<String> vecindarios = [];
    try {
      if (_selectedDistrito != null && _selectedDistrito!.isNotEmpty) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Distritos')
            .doc(_selectedDistrito)
            .collection('Vecindarios')
            .get();
        for (var doc in querySnapshot.docs) {
          vecindarios.add(doc.id); // El id del documento es el nombre del vecindario
        }
      }
    } catch (e) {
      debugPrint("Error al obtener vecindarios de Firestore: $e");
    }
    return vecindarios;
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
    fechaNacimientoController = TextEditingController();
    direccionDetalladaController = TextEditingController();
    _loadUserProfile(); // Cargar el perfil al inicializar el ViewModel
    _cargarDistritos(); // Cargar distritos al inicializar el ViewModel
    _cargarVecindarios();
  }

  Future<void> _cargarDistritos() async {
    try {
      final lista = await getDistritosFromFirestore();
      distritos = lista;
      if (lista.isNotEmpty && _selectedDistrito == null) {
        _selectedDistrito = lista.first;
      }
    } catch (e) {
      debugPrint("Error al cargar distritos: $e");
    }
  }

  Future<void> _cargarVecindarios() async {
    try {
      final lista = await getVecindariosFromFirestore();
      vecindarios = lista;
      if (lista.isNotEmpty && _selectedVecindario == null) {
        _selectedVecindario = lista.first;
      }
    } catch (e) {
      debugPrint("Error al cargar vecindarios: $e");
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

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        _user = Usuario.fromFirestore(userDoc, uid);
        // Inicializar controladores y propiedades con los datos del usuario
        nombreCompletoController.text = _user.nombre;
        emailController.text = _user.email;
        dniController.text = _user.dni?.toString() ?? '';
        numeroTelefonoController.text = _user.numeroTelefono?.toString() ?? '';
        _selectedFechaNacimiento = _user.fechaNacimiento;

        fechaNacimientoController.text = _user.fechaNacimiento == null
            ? ''
            : DateFormat('dd/MM/yyyy').format(_user.fechaNacimiento!);
        _selectedGenero = _user.genero;
        _selectedProvincia = _user.provincia;
        _selectedDistrito = _user.distrito;
        _selectedVecindario = _user.vecindario;
        direccionDetalladaController.text = _user.direccionDetallada ?? '';
      } else {
        _errorMessage =
            "Datos de perfil no encontrados en Firestore para el UID: $uid. Se inicializa un perfil básico.";
        // Si el documento no existe, inicializa _user con datos básicos
        _user = Usuario(
          id: uid,
          nombre: 'Usuario Nuevo',
          email:
              firebase_auth.FirebaseAuth.instance.currentUser?.email ??
              'nuevo_usuario@example.com',
          empadronado: false,
          // Inicializa las nuevas propiedades con valores predeterminados o nulos
          provincia: null,
          distrito: null,
          urbanizacion: null,
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
        emailController.text =
            _user.email; // Establece el email del usuario de Auth
        fechaNacimientoController.clear();
        direccionDetalladaController.clear();
        _selectedFechaNacimiento = null;
        _selectedGenero = null;
        _selectedProvincia = null;
        _selectedDistrito = null;
        _selectedVecindario = null;}
    } on FirebaseException catch (e) {
      _errorMessage = "Error de Firebase al cargar perfil: ${e.message}";
      debugPrint("Error Firebase al cargar perfil: $e");
    } catch (e) {
      _errorMessage = "Error al cargar el perfil: $e";
      debugPrint("Error general al cargar perfil: $e");
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
      selectedFechaNacimiento =
          pickedDate; // Usa el setter para actualizar y notificar
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

      /*
      String? newImageUrl =
          _user.imageUrl; // Mantener la URL existente por defecto

       Si hay una nueva imagen seleccionada, subirla a Firebase Storage
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$uid.jpg');
        await storageRef.putFile(_imageFile!);
        newImageUrl = await storageRef.getDownloadURL();
      }
      */

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
          _selectedDistrito != null &&
          direccionDetalladaController.text.trim().isNotEmpty;

      // Crear un nuevo objeto Usuario con los datos actualizados de los controladores y propiedades
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
      );

      await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(uid)
          .set(updatedUser.toFirestore(), SetOptions(merge: true));

      _user = updatedUser; // Actualiza el _user localmente

      _errorMessage = null; // Limpiar cualquier mensaje de error anterior
    } on FirebaseException catch (e) {
      _errorMessage = "Error de Firebase al actualizar perfil: ${e.message}";
      debugPrint("Error Firebase al actualizar perfil: $e"); // Usar debugPrint
    } catch (e) {
      _errorMessage = "Error al actualizar el perfil: $e";
      debugPrint("Error general al actualizar perfil: $e"); // Usar debugPrint
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
