// lib/features/auth/view/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/app_logo.dart'; // Si tu AppLogo existe
import '../../../app/theme/app_colors.dart';
import '../viewmodel/auth_viewmodel.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // late AuthViewModel _viewModel; // No es necesario si se obtiene del MultiProvider

  @override
  void initState() {
    super.initState();
    // _viewModel = AuthViewModel(); // No es necesario si se obtiene del MultiProvider
  }

  @override
  void dispose() {
    // Si AuthViewModel está en MultiProvider, Provider.of<AuthViewModel>(context, listen: false).disposeControllers();
    // _viewModel.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context); // Obtenemos el ViewModel

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column( // Eliminado Consumer aquí ya que vm se obtiene al inicio del build
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(), 
              const SizedBox(height: 16),
              const Text(
                "RECUPERAR CONTRASEÑA",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ingresa tu correo y te enviaremos instrucciones",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 32),

              AppTextField(
                controller: vm.emailController,
                hintText: "Correo electrónico",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 24),

              AppButton( // Botón para enviar instrucciones (descomentado y conectado al VM)
                label: "Enviar instrucciones",
                onPressed: vm.isLoading ? null : () => vm.recuperarContrasena(context),
                isDisabled: vm.isLoading,
              ),

              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Volver al login",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}