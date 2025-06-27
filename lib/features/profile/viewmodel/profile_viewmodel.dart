import 'dart:io';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '/app/theme/app_colors.dart'; // Asegúrate de importar AppColors si lo usas en el DatePicker builder

class ProfileViewmodel extends ChangeNotifier {
  // Simulación de un usuario inicial cargado.
  // Se utilizará lógica en firebase
  User _user = User(
    id: 'user_brei_19',
    name: 'Brei uwu',
    email: 'brei@gmail.com',
    phone: '000000000',
    dni: '00000000',
    // ¡CORRECCIÓN AQUÍ! Cambiar a (año, mes, día)
    dateOfBirth: DateTime(2006, 07, 24), // Correcto: (Año, Mes, Día)
    gender: 'Masculino',
  );

  bool _isLoading = false;
  String? _errorMessage;

  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dniController = TextEditingController();

  // Variables para la fecha de nacimiento y género
  DateTime? _selectedDateOfBirth;
  String? _selectedGender;

  ProfileViewmodel() {
    // Cargar los datos iniciales del usuario en los controladores y variables
    _loadInitialUserData();
  }

  // Getters para acceder al estado
  User get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedDateOfBirth => _selectedDateOfBirth;
  String? get selectedGender => _selectedGender;

  // Setters para actualizar las variables reactivas
  set selectedDateOfBirth(DateTime? date) {
    _selectedDateOfBirth = date;
    notifyListeners(); // Notifica a los listeners que la fecha ha cambiado
  }

  set selectedGender(String? gender) {
    _selectedGender = gender;
    notifyListeners(); // Notifica a los listeners que el género ha cambiado
  }

  // Método para inicializar los controladores y variables con los datos del usuario actual
  void _loadInitialUserData() {
    nameController.text = _user.name;
    emailController.text = _user.email;
    phoneController.text = _user.phone;
    dniController.text = _user.dni;
    _selectedDateOfBirth = _user.dateOfBirth;
    _selectedGender = _user.gender;
    notifyListeners(); // Asegura que la UI se actualice con los datos iniciales
  }

  // Método para actualizar la imagen de perfil
  void updateImage(File image) {
    _user.imageFile = image; // Almacena el archivo localmente
    notifyListeners();
  }

  // Método para guardar los cambios en el perfil
  Future<void> saveProfileChanges() async {
    _isLoading = true;
    _errorMessage = null; // Limpia cualquier error anterior
    notifyListeners();

    try {
      // Validaciones básicas de campos
      if (nameController.text.trim().isEmpty ||
          phoneController.text.trim().isEmpty ||
          dniController.text.trim().isEmpty ||
          _selectedDateOfBirth == null ||
          _selectedGender == null) {
        throw Exception('Por favor, completa todos los campos obligatorios (*).');
      }

      // Crear una nueva instancia de User con los datos actualizados de los controladores
      final updatedUser = User(
        id: _user.id, // Mantener el ID del usuario
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        dni: dniController.text.trim(),
        imageFile: _user.imageFile, // Mantiene la imagen local si se seleccionó una nueva
        imageUrl: _user.imageUrl, // Mantiene la URL existente (o la nueva si se subió)
        dateOfBirth: _selectedDateOfBirth,
        gender: _selectedGender,
      );

      /* Lógica del firebase*/
      // Simular una operación de red/base de datos
      await Future.delayed(const Duration(seconds: 2));

      _user = updatedUser; // Actualiza el usuario en el ViewModel con los datos guardados
      debugPrint('Perfil actualizado con éxito: ${_user.name}'); // Usar debugPrint
    } catch (e) {
      _errorMessage = 'Error al guardar el perfil: ${e.toString()}';
      debugPrint('Error en saveProfileChanges: $_errorMessage'); // Usar debugPrint
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para seleccionar la fecha de nacimiento usando un DatePicker
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime firstAllowedDate = DateTime(1900, 1, 1);
    final DateTime lastAllowedDate = DateTime.now();

    // Aseguramos que initialDate sea válido y esté dentro del rango
    DateTime initialDateToUse = _selectedDateOfBirth ?? lastAllowedDate;

    if (initialDateToUse.isBefore(firstAllowedDate)) {
      initialDateToUse = firstAllowedDate;
    }
    if (initialDateToUse.isAfter(lastAllowedDate)) {
      initialDateToUse = lastAllowedDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateToUse, // Usamos la fecha ya validada
      firstDate: firstAllowedDate,   // Desde el año 1900
      lastDate: lastAllowedDate,     // Hasta hoy
      locale: const Locale('es', 'ES'), // Asegura que el DatePicker esté en español
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      // Añadir el builder para personalizar los colores del DatePicker
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // O AppColors.primary
              onPrimary: AppColors.buttonText, // Color del texto en el encabezado del picker
              onSurface: AppColors.text, // Color del texto en el calendario (días, meses)
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor, // O AppColors.primary
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDateOfBirth) {
      selectedDateOfBirth = pickedDate; // Usa el setter para notificar cambios
    }
  }

  @override
  void dispose() {
    // Desecha los controladores para evitar fugas de memoria
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dniController.dispose();
    super.dispose();
  }
}