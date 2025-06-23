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
  late AuthViewModel _viewModel;
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
  }

  @override
  void dispose() {
    _viewModel.disposeControllers();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("Crear Cuenta"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Consumer<AuthViewModel>(
              builder: (_, vm, __) => SingleChildScrollView(
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
                      controller: nameController,
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
                      controller: confirmPasswordController,
                      hintText: "Confirmar contraseña",
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),

                    AppButton(
                      label: "Crear Cuenta",
                      onPressed: vm.isLoading ? () {} : () => vm.fakeRegister(context),
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
        ),
      ),
    );
  }
}
