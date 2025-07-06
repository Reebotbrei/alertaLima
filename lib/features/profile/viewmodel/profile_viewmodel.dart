import 'dart:io'; // Para File
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias para evitar conflicto de nombres
import 'package:firebase_storage/firebase_storage.dart'; // Para Firebase Storage
import '../../../app/Objetitos/usuario.dart'; 
import 'package:intl/intl.dart'; // Para DateFormat

import '../../../main.dart';

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
  late TextEditingController fechaNacimientoController; // <--- CAMBIO AQUÍ: Nuevo controlador para la fecha
  late TextEditingController direccionDetalladaController; // <--- CAMBIO AQUÍ: Nuevo controlador para la dirección detallada

  // Propiedades para la selección de fecha y género, ajustadas a los nombres del modelo Usuario
  DateTime? _selectedFechaNacimiento;
  DateTime? get selectedFechaNacimiento => _selectedFechaNacimiento;
  set selectedFechaNacimiento(DateTime? date) {
    _selectedFechaNacimiento = date;
    fechaNacimientoController.text = date == null ? '' : DateFormat('dd/MM/yyyy').format(date); // Actualiza el controlador
    notifyListeners();
  }

  String? _selectedGenero; // Antes _selectedGender
  String? get selectedGenero => _selectedGenero;
  set selectedGenero(String? gender) {
    _selectedGenero = gender;
    notifyListeners();
  }

  // Propiedades para los dropdowns de dirección
  String? _selectedProvincia; // <--- CAMBIO AQUÍ: Nueva propiedad
  String? get selectedProvincia => _selectedProvincia;
  set selectedProvincia(String? value) {
    _selectedProvincia = value;
    notifyListeners();
  }

  String? _selectedDistrito; // <--- CAMBIO AQUÍ: Nueva propiedad
  String? get selectedDistrito => _selectedDistrito;
  set selectedDistrito(String? value) {
    _selectedDistrito = value;
    notifyListeners();
  }

  String? _selectedUrbanizacion; // <--- CAMBIO AQUÍ: Nueva propiedad
  String? get selectedUrbanizacion => _selectedUrbanizacion;
  set selectedUrbanizacion(String? value) {
    _selectedUrbanizacion = value;
    notifyListeners();
  }

  // Listas de opciones para los dropdowns (puedes cargarlas dinámicamente de tu backend)
  final List<String> provincias = ['LIMA']; //Ejemplo de datos
  final List<String> distritos = ['ANCON',
                                  'ATE', 
                                  'BARRANCO',
                                  'BREÑA', 
                                  'CHACLACAYO', 
                                  'CARABAYLLO',
                                  'CHORRILLOS',
                                  'CIENEGUILLA',
                                  'COMAS',
                                  'EL AGUSTINO',
                                  'INDEPENDENCIA',
                                  'JESUS MARIA',
                                  'LA MOLINA',
                                  'LA VICTORIA',
                                  'LIMA',
                                  'LINCE',
                                  'LOS OLIVOS',
                                  'LURIGANCHO',
                                  'LURIN',
                                  'MAGDALENA DEL MAR',
                                  'MIRAFLORES',
                                  'PACHAMAC',
                                  'PUCUSANA',
                                  'PUEBLO LIBRE',
                                  'PUENTE PIEDRA',
                                  'PUNTA HERMOSA',
                                  'PUNTA NEGRA',
                                  'RIMAC',
                                  'SAN BARTOLO',
                                  'SAN ISIDRO',
                                  'SAN JUAN DE LURIGANCHO',
                                  'SAN JUAN DE MIRAFLORES',
                                  'SAN LUIS',
                                  'SAN MARTIN DE PORRES',
                                  'SAN MIGUEL',
                                  'SANTA ANITA',
                                  'SANTA MARIA DEL MAR',
                                  'SANTA ROSA',
                                  'SANTIAGO DE SURCO',
                                  'SURQUILLO',
                                  'VILLA EL SALVADOR',
                                  'VILLA MARIA DEL TRIUNFO',
                                  ];
  final List<String> urbanizaciones = ['LIMA']; 


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

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();

      if (userDoc.exists) {
        _user = Usuario.fromFirestore(userDoc);
        // Inicializar controladores y propiedades con los datos del usuario
        nombreCompletoController.text = _user.nombre;
        emailController.text = _user.email;
        dniController.text = _user.dni?.toString() ?? '';
        numeroTelefonoController.text = _user.numeroTelefono ?? '';
        _selectedFechaNacimiento = _user.fechaNacimiento;
        // Actualiza el controlador de fecha
        fechaNacimientoController.text = _user.fechaNacimiento == null
            ? ''
            : DateFormat('dd/MM/yyyy').format(_user.fechaNacimiento!); 
        _selectedGenero = _user.genero;
        _selectedProvincia = _user.provincia; 
        _selectedDistrito = _user.distrito; 
        _selectedUrbanizacion = _user.urbanizacion; 
        direccionDetalladaController.text = _user.direccionDetallada ?? ''; 

      } else {
        _errorMessage = "Datos de perfil no encontrados en Firestore para el UID: $uid. Se inicializa un perfil básico.";
        // Si el documento no existe, inicializa _user con datos básicos
        _user = Usuario(
          uid: uid,
          nombre: 'Usuario Nuevo',
          email: firebase_auth.FirebaseAuth.instance.currentUser?.email ?? 'nuevo_usuario@example.com',
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
        emailController.text = _user.email; // Establece el email del usuario de Auth
        fechaNacimientoController.clear(); 
        direccionDetalladaController.clear(); 
        _selectedFechaNacimiento = null;
        _selectedGenero = null;
        _selectedProvincia = null;
        _selectedDistrito = null; 
        _selectedUrbanizacion = null;
      }
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
      selectedFechaNacimiento = pickedDate; // Usa el setter para actualizar y notificar
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
      if (_selectedProvincia == null || _selectedDistrito == null) {
        _errorMessage = "Provincia y Distrito son obligatorios.";
        _isLoading = false;
        notifyListeners();
        return;
      }


      // Crear un nuevo objeto Usuario con los datos actualizados de los controladores y propiedades
      final updatedUser = _user.copyWith(
        nombre: nombreCompletoController.text.trim(),
        email: emailController.text.trim(),
        dni: int.tryParse(dniController.text.trim()),
        numeroTelefono: numeroTelefonoController.text.trim(),
        fechaNacimiento: _selectedFechaNacimiento,
        genero: _selectedGenero,
        imageUrl: newImageUrl,
        // Añadir las nuevas propiedades de dirección
        provincia: _selectedProvincia,
        distrito: _selectedDistrito,
        urbanizacion: _selectedUrbanizacion,
        direccionDetallada: direccionDetalladaController.text.trim(),
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
        debugPrint("Error: No se pudo mostrar SnackBar porque navigatorKey.currentContext no está montado."); // Usar debugPrint
      }

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