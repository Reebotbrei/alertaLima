import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/view/login_screen.dart';
import 'features/auth/view/register_screen.dart';
import 'features/auth/view/forgot_password_screen.dart';
import 'features/sos/view/sos_screen.dart';
import 'features/sos/viewmodel/sos_viewmodel.dart';


void main() {
  runApp(const AlertaLimaApp());
}

class AlertaLimaApp extends StatelessWidget {
  const AlertaLimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SOSViewModel()),
      ],
      child:MaterialApp(
        title: 'Alerta Lima',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/', // Empieza con SosScreen
        routes: {
        '/': (context) => const SosScreen(),      // Pantalla inicial
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const Placeholder(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        },
      )

    );
  }
}
