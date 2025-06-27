import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Importa DateFormat
import '../viewmodel/profile_viewmodel.dart';
import '/app/theme/app_colors.dart'; // Importa AppColors

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar perfil'),
        backgroundColor: Theme.of(context).primaryColor, // Usar el color primario del tema
      ),
      body: Consumer<ProfileViewmodel>(
        builder: (context, profileVM, child) {
          if (profileVM.isLoading) {
            return const Center(child: CircularProgressIndicator()); // Corregido de CircularLoadingIndicator
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Sección de la foto de perfil
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.muted.withOpacity(0.2),
                      // Lógica para mostrar la imagen:
                      // 1. Imagen seleccionada temporalmente (FileImage)
                      // 2. URL de imagen existente (NetworkImage)
                      // 3. Icono por defecto
                      backgroundImage: profileVM.imageFile != null
                          ? FileImage(profileVM.imageFile!) as ImageProvider<Object>?
                          : (profileVM.user.imageUrl?.isNotEmpty == true
                                  ? NetworkImage(profileVM.user.imageUrl!) as ImageProvider<Object>?
                                  : null),
                      child: (profileVM.imageFile == null && (profileVM.user.imageUrl?.isEmpty == true || profileVM.user.imageUrl == null))
                          ? Icon(Icons.person, size: 60, color: AppColors.muted)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton(
                        onPressed: () => _pickImage(context, profileVM), // Pasar profileVM para usar updateImage
                        mini: true,
                        backgroundColor: AppColors.button,
                        child: const Icon(Icons.edit, color: AppColors.buttonText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Información de la cuenta',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),

                // Campo de Nombre completo
                _buildTextField(
                  context,
                  controller: profileVM.nombreCompletoController, // ACTUALIZADO: de nameController a nombreCompletoController
                  labelText: 'Nombre completo*',
                  keyboardType: TextInputType.name,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.nombreCompletoController.clear(), // ACTUALIZADO
                  ),
                ),
                const SizedBox(height: 15),

                // Campo de Fecha de Nacimiento con selector de fecha
                GestureDetector(
                  onTap: () => profileVM.selectDateOfBirth(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      context,
                      controller: TextEditingController( // Este controlador es solo para mostrar
                        text: profileVM.selectedFechaNacimiento == null // ACTUALIZADO: de selectedDateOfBirth a selectedFechaNacimiento
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(profileVM.selectedFechaNacimiento!), // ACTUALIZADO
                      ),
                      labelText: 'Fecha de Nacimiento*',
                      hintText: 'DD/MM/AAAA',
                      suffixIcon: const Icon(Icons.calendar_today),
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Selección de Género
                _buildGenderSelection(context, profileVM),
                const SizedBox(height: 15),

                // Campo de Número de identificación (DNI)
                _buildTextField(
                  context,
                  controller: profileVM.dniController,
                  labelText: 'Número de identificación*',
                  keyboardType: TextInputType.number,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.dniController.clear(),
                  ),
                ),
                const SizedBox(height: 15),

                // Campo de Número de teléfono
                _buildTextField(
                  context,
                  controller: profileVM.numeroTelefonoController, // ACTUALIZADO: de phoneController a numeroTelefonoController
                  labelText: 'Número de teléfono*',
                  keyboardType: TextInputType.phone,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.numeroTelefonoController.clear(), // ACTUALIZADO
                  ),
                ),
                const SizedBox(height: 15),

                // Campo de Email (generalmente no editable directamente)
                _buildTextField(
                  context,
                  controller: profileVM.emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.emailController.clear(),
                  ),
                  readOnly: true, // El email no suele ser editable en el perfil
                ),
                const SizedBox(height: 30),

                // Botón de Guardar Cambios
                ElevatedButton(
                  onPressed: profileVM.isLoading
                      ? null
                      : () async {
                          await profileVM.saveProfileChanges();
                          // La notificación con SnackBar ahora se gestiona en el ViewModel
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: AppColors.buttonText,
                    minimumSize: const Size(double.infinity, 50), // Ancho completo
                  ),
                  child: profileVM.isLoading
                      ? const CircularProgressIndicator(color: AppColors.buttonText)
                      : const Text(
                          'Guardar Cambios',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                // Mensaje de error
                if (profileVM.errorMessage != null && !profileVM.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      profileVM.errorMessage!,
                      style: const TextStyle(color: AppColors.error, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Método para seleccionar imagen del perfil (ahora pasa profileVM)
  Future<void> _pickImage(BuildContext context, ProfileViewmodel profileVM) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      profileVM.updateImage(image);
    }
  }

  // Widget para construir un campo de texto reutilizable
  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder( // Diseño de borde
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.muted, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
        filled: true,
        fillColor: AppColors.background, // Usar textFieldBackground de AppColors
      ),
      style: TextStyle(color: AppColors.text), // Color del texto de entrada
      cursorColor: AppColors.primary, // Color del cursor
    );
  }

  // Widget para construir la sección de selección de género
  Widget _buildGenderSelection(BuildContext context, ProfileViewmodel viewModel) {
    return Column( // O Row, si prefieres que "Género *" esté en la misma línea que las opciones.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 8), // Espacio entre el título y las opciones
        // Aquí es donde puedes decidir si quieres que los radios estén en una fila (Row) o columna (Column).
        // Las imágenes anteriores mostraban desbordamiento con Row, por eso se sugirió Column.
        // Si quieres Row, asegúrate de que cada opción tenga un Expanded o Flexible.
        Column( // Cambiado a Column para apilar verticalmente y evitar desbordamiento [cite: Imagen de WhatsApp 2025-06-27 a las 01.59.40_1df8851c.jpg]
          crossAxisAlignment: CrossAxisAlignment.start, // Alinea los radios a la izquierda
          children: <Widget>[
            _buildGenderOption(context, viewModel, 'Masculino'),
            _buildGenderOption(context, viewModel, 'Femenino'),
            _buildGenderOption(context, viewModel, 'Desconocida'),
          ],
        ),
      ],
    );
  }

  // Widget auxiliar para construir cada opción de radio de género
  Widget _buildGenderOption(BuildContext context, ProfileViewmodel viewModel, String gender) {
    return Row( // Cada opción en un Row individual
      mainAxisSize: MainAxisSize.min, // El Row solo ocupa el espacio necesario
      children: [
        Radio<String>(
          value: gender,
          groupValue: viewModel.selectedGenero, // ACTUALIZADO: de selectedGender a selectedGenero
          onChanged: (String? value) {
            viewModel.selectedGenero = value; // ACTUALIZADO
          },
          activeColor: AppColors.primary,
        ),
        Text(gender, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.text)),
      ],
    );
  }
}
