// lib/features/profile/view/profile_screen.dart

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
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Este es el Column padre que envuelve todo.
                                                          // Si quieres que todos los elementos estén a la izquierda,
                                                          // cámbialo a CrossAxisAlignment.start
              children: [
                // Sección de la foto de perfil
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.muted.withOpacity(0.2),
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
                        onPressed: () => _pickImage(context, profileVM),
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
                  controller: profileVM.nombreCompletoController,
                  labelText: 'Nombre completo*',
                  keyboardType: TextInputType.name,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.nombreCompletoController.clear(),
                  ),
                ),
                const SizedBox(height: 15),

                // Campo de Fecha de Nacimiento con selector de fecha
                GestureDetector(
                  onTap: () => profileVM.selectDateOfBirth(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      context,
                      controller: TextEditingController(
                        text: profileVM.selectedFechaNacimiento == null
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(profileVM.selectedFechaNacimiento!),
                      ),
                      labelText: 'Fecha de Nacimiento*',
                      hintText: 'DD/MM/AAAA',
                      suffixIcon: const Icon(Icons.calendar_today),
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Sección de selección de género
                // Para que esta sección se alinee a la izquierda,
                // su contenedor padre (este Column o un Align) debe permitirlo.
                // Si el Column principal tiene CrossAxisAlignment.center, esta sección también se centrará.
                Align( // Añadimos Align para forzar la alineación a la izquierda si el padre es centrado
                  alignment: Alignment.centerLeft,
                  child: _buildGenderSelection(context, profileVM),
                ),
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
                  controller: profileVM.numeroTelefonoController,
                  labelText: 'Número de teléfono*',
                  keyboardType: TextInputType.phone,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.numeroTelefonoController.clear(),
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
                  readOnly: true,
                ),
                const SizedBox(height: 30),

                // Botón de Guardar Cambios
                ElevatedButton(
                  onPressed: profileVM.isLoading
                      ? null
                      : () async {
                          await profileVM.saveProfileChanges();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: AppColors.buttonText,
                    minimumSize: const Size(double.infinity, 50),
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

  // Método para seleccionar imagen del perfil
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
        border: OutlineInputBorder(
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
        fillColor: AppColors.background,
      ),
      style: TextStyle(color: AppColors.text),
      cursorColor: AppColors.primary,
    );
  }

  // Widget para construir la sección de selección de género
  Widget _buildGenderSelection(BuildContext context, ProfileViewmodel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido de esta columna a la izquierda
      children: [
        Text(
          'Género *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 8),
        // Las opciones de radio también dentro de una columna para apilarse verticalmente
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinea cada Radio a la izquierda
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
    return Row(
      mainAxisSize: MainAxisSize.min, // Ocupa el espacio mínimo necesario
      children: [
        Radio<String>(
          value: gender,
          groupValue: viewModel.selectedGenero,
          onChanged: (String? value) {
            viewModel.selectedGenero = value;
          },
          activeColor: AppColors.primary,
        ),
        Text(gender, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.text)),
      ],
    );
  }
}