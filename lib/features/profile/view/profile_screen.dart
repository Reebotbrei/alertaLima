import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodel/profile_viewmodel.dart';
import '/app/theme/app_colors.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar perfil'),
        backgroundColor: Theme.of(
          context,
          ).primaryColor, // Usar el color primario del tema
      ),
      body: Consumer<ProfileViewmodel>(
        builder: (context, profileVM, child) {
          if (profileVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
                  textAlign: TextAlign.center, 
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
                      controller: profileVM.fechaNacimientoController, // Usar el controlador del VM
                      labelText: 'Fecha de Nacimiento*',
                      hintText: 'DD/MM/AAAA',
                      suffixIcon: const Icon(Icons.calendar_today),
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Sección de Género
                Align(
                  alignment: Alignment.centerLeft, 
                  child: _buildGenderSelection(context, profileVM),
                ),
                const SizedBox(height: 15),

                // Campo de Número de identificación (DNI)
                _buildTextField(
                  context,
                  controller: profileVM.dniController,
                  labelText: 'DNI*',
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

                // Campo de Email
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

                // Campo direccion
                Text(
                  'Dirección Actual',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Dropdown Provincia/Ciudad
                DropdownButtonFormField<String>(
                  value: profileVM.selectedProvincia,
                  decoration: InputDecoration(
                    labelText: 'Provincia/ Ciudad*',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                  items: profileVM.provincias.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: AppColors.text)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      profileVM.selectedProvincia = newValue;
                    }
                  },
                ),
                const SizedBox(height: 15),

                // Dropdown Distrito
                DropdownButtonFormField<String>(
                  value: profileVM.selectedDistrito,
                  decoration: InputDecoration(
                    labelText: 'Distrito*',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                  items: profileVM.distritos.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: AppColors.text)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      profileVM.selectedDistrito = newValue;
                    }
                  },
                ),
                const SizedBox(height: 15),

                // Dropdown Urbanización
                DropdownButtonFormField<String>(
                  value: profileVM.selectedUrbanizacion,
                  decoration: InputDecoration(
                    labelText: 'Urbanización',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                  items: profileVM.urbanizaciones.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: AppColors.text)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      profileVM.selectedUrbanizacion = newValue;
                    }
                  },
                ),
                const SizedBox(height: 15),

                // Campo de Dirección detallada
                _buildTextField(
                  context,
                  controller: profileVM.direccionDetalladaController,
                  labelText: 'Dirección detallada',
                  keyboardType: TextInputType.streetAddress,
                  maxLines: 3,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.direccionDetalladaController.clear(),
                  ),
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
    int? maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines, // Se usa aquí
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
  Widget _buildGenderSelection(
    BuildContext context, 
    ProfileViewmodel viewModel
    ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Text(
          'Género *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 8),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            _buildGenderOption(context, viewModel, 'Masculino'),
            _buildGenderOption(context, viewModel, 'Femenino'),
          ],
        ),
      ],
    );
  }

  // Widget auxiliar para construir cada opción de radio de género
  Widget _buildGenderOption(BuildContext context, ProfileViewmodel viewModel, String gender) {
    return RadioListTile<String>(
      title: Text(gender, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.text)),
      value: gender,
      groupValue: viewModel.selectedGenero,
      onChanged: (String? value) {
        viewModel.selectedGenero = value;
      },
      activeColor: AppColors.primary,
      dense: true,
      contentPadding: EdgeInsets.zero, 
    );
  }
}