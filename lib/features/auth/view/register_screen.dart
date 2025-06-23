import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/app_logo.dart';
import '../../../app/theme/app_colors.dart';
import '../viewmodel/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AuthViewModel _viewModel;

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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Consumer<AuthViewModel>(
              builder: (_, vm, __) => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: 16),
                    const Text(
                      "CREA TU CUENTA",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Completa los datos para continuar",
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 32),

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
                    const SizedBox(height: 24),

                    AppButton(
                      label: "Registrarse",
                      onPressed: vm.isLoading ? () {} : () => vm.fakeRegister(context),
                      isDisabled: vm.isLoading,
                    ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "¿Ya tienes una cuenta? Inicia sesión",
                        style: TextStyle(color: AppColors.primary),
                      ),
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
