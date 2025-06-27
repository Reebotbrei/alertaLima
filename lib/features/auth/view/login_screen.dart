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
  late AuthViewModel _viewModel;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
  }

  @override
  void dispose() {
    _viewModel.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<AuthViewModel>(
            builder: (_, vm, __) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppLogo(),
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
                          iconEye: _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                          onPressed: vm.isLoading
                              ? () {}
                              : () => vm.login(context),
                          isDisabled: vm.isLoading,
                        ),

                        const SizedBox(height: 16),

                        // Botón Google
                        OutlinedButton.icon(
                          onPressed: () {}, // futura autenticación
                          icon: const Icon(
                            Icons.login,
                            color: AppColors.text,
                            size: 26,
                          ),
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
        ),
      ),
    );
  }
}
