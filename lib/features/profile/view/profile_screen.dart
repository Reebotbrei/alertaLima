import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodel/profile_viewmodel.dart';
import '/app/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Método para seleccionar imagen del perfil
  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      Provider.of<ProfileViewmodel>(context, listen: false).updateImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar perfil'),
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
                      backgroundColor: AppColors.muted.withOpacity(0.2), // Fondo del avatar
                      backgroundImage: profileVM.user.imageFile != null
                          ? FileImage(profileVM.user.imageFile!)
                          : (profileVM.user.imageUrl?.isNotEmpty == true
                              ? NetworkImage(profileVM.user.imageUrl!) as ImageProvider
                              : null),
                      child: (profileVM.user.imageFile == null && (profileVM.user.imageUrl?.isEmpty == true || profileVM.user.imageUrl == null))
                          ? Icon(Icons.person, size: 60, color: AppColors.muted) // Ícono de persona por defecto
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton(
                        onPressed: () => _pickImage(context),
                        mini: true,
                        backgroundColor: AppColors.button, // Color del botón de editar
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
                  controller: profileVM.nameController,
                  labelText: 'Nombre completo*',
                  keyboardType: TextInputType.name,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.nameController.clear(),
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
                        text: profileVM.selectedDateOfBirth == null
                            ? ''
                            : '${profileVM.selectedDateOfBirth!.day.toString().padLeft(2, '0')}/${profileVM.selectedDateOfBirth!.month.toString().padLeft(2, '0')}/${profileVM.selectedDateOfBirth!.year}',
                      ),
                      labelText: 'Fecha de Nacimiento*',
                      hintText: 'DD/MM/AAAA',
                      suffixIcon: const Icon(Icons.calendar_today),
                      readOnly: true, //
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Selección de Género
                _buildGenderSelection(context, profileVM),
                const SizedBox(height: 15),

                // Campo de Número de identificación
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
                  controller: profileVM.phoneController,
                  labelText: 'Número de teléfono*',
                  keyboardType: TextInputType.phone,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => profileVM.phoneController.clear(),
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
                ),
                const SizedBox(height: 30),

                // Botón de Guardar Cambios
                ElevatedButton(
                  onPressed: profileVM.isLoading
                      ? null
                      : () async {
                          await profileVM.saveProfileChanges();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(profileVM.errorMessage ?? 'Perfil actualizado con éxito!'),
                              backgroundColor: profileVM.errorMessage == null ? AppColors.success : AppColors.error,
                            ),
                          );
                        },
                  child: profileVM.isLoading
                      ? const CircularProgressIndicator(color: AppColors.buttonText)
                      : const Text(
                          'Guardar Cambios',
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

  // Widget para construir un campo de texto reutilizable
  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    bool readOnly = false, // Propiedad para hacer el campo de solo lectura
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      
        suffixIcon: suffixIcon,
      ),
    );
  }

  // Widget para construir la sección de selección de género
  Widget _buildGenderSelection(BuildContext context, ProfileViewmodel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género *',
          style: Theme.of(context).textTheme.titleLarge, // Usa el estilo de título del tema
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinea los Rows a la izquierda
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
      children: [
        Radio<String>(
          value: gender,
          groupValue: viewModel.selectedGender,
          onChanged: (String? value) {
            viewModel.selectedGender = value;
          },
          activeColor: AppColors.primary, // Color del radio button seleccionado
        ),
        Text(gender, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.text)), // Estilo del texto
      ],
    );
  }
}