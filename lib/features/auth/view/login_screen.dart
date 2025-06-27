// lib/features/auth/view/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/app_logo.dart';
import '../../../app/theme/app_colors.dart';
import '../viewmodel/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Asegúrate de que AuthViewModel se inicialice como un ChangeNotifierProvider
  // Si ya lo tienes en el MultiProvider de main.dart, puedes obtenerlo con Provider.of
  // late AuthViewModel _viewModel; // No es necesario si se obtiene del MultiProvider

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Si AuthViewModel ya está en MultiProvider, no necesitas esta línea
    // _viewModel = AuthViewModel();
  }

  @override
  void dispose() {
    // Si AuthViewModel está en MultiProvider, Provider.of<AuthViewModel>(context, listen: false).disposeControllers();
    // O puedes mover los controladores al AuthViewModel si no quieres pasarlos por aquí
    // _viewModel.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Es más eficiente obtener el ViewModel directamente si ya está en MultiProvider
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top, // Ajuste para SafeArea
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(), // Si tu AppLogo existe
                    const SizedBox(height: 16),
                    const Text(
                      "LIMA EN ACCIÓN",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Inicia sesión para continuar",
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 32),

                    // Email
                    AppTextField(
                      controller: vm.emailController,
                      hintText: "Correo electrónico",
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AppTextField(
                      controller: vm.passwordController,
                      hintText: "Contraseña",
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      iconEye: _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      onEyeTab: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Botón Iniciar sesión
                    AppButton(
                      label: "Iniciar Sesión",
                      onPressed: vm.isLoading ? null : () => vm.login(context), // Cambiado a null para deshabilitar
                      isDisabled: vm.isLoading,
                    ),

                    const SizedBox(height: 16),

                    // Botón Google (futura autenticación)
                    OutlinedButton.icon(
                      onPressed: () {},
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ¿Olvidaste tu contraseña?
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot');
                      },
                      child: const Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),

                    // ¿No tienes cuenta? Regístrate
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿No tienes una cuenta? ",
                          style: TextStyle(color: AppColors.text),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            "Regístrate",
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
        ),
      ),
    );
  }
}