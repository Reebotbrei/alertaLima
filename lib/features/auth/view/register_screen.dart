import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_text_field.dart';
import '../viewmodel/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la instancia del AuthViewModel proporcionada por MultiProvider
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Crear Cuenta"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Limpia los controladores del AuthViewModel cuando vuelvas atrás
            vm.emailController.clear();
            vm.passwordController.clear();
            vm.nombreControlador.clear();
            vm.confirmaContrasenaControlador.clear();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(

            child: Column(
              children: [
                const Icon(Icons.person_add_alt_1, size: 80, color: AppColors.primary),
                const SizedBox(height: 16),
                const Text(
                  "Regístrate para continuar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),

                AppTextField(
                  controller: vm.nombreControlador,
                  hintText: "Nombre completo",
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: vm.emailController,
                  hintText: "Correo electrónico",
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: vm.passwordController,
                  hintText: "Contraseña",
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: vm.confirmaContrasenaControlador,
                  hintText: "Confirmar contraseña",
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                AppButton(
                  label: "Crear Cuenta",
                  onPressed: vm.isLoading ? null : () => vm.registro(context), // Cambiado a null para deshabilitar
                  isDisabled: vm.isLoading,
                ),
                const SizedBox(height: 16),

                OutlinedButton.icon(
                  onPressed: () {}, // futura autenticación
                  icon: const Icon(Icons.login, color: AppColors.text, size: 26),
                  label: const Text(
                    "Registrarse con Google",
                    style: TextStyle(color: AppColors.text),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿Ya tienes una cuenta? ", style: TextStyle(color: AppColors.text)),
                    TextButton(
                      onPressed: () {
                        
                        vm.emailController.clear();
                        vm.passwordController.clear();
                        vm.nombreControlador.clear();
                        vm.confirmaContrasenaControlador.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Inicia sesión",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}