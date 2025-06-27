import 'package:alerta_lima/features/chat/view/chat_screen.dart';
import 'package:alerta_lima/features/dashboard/view/home_screen.dart';
import 'package:alerta_lima/features/profile/view/profile_screen.dart';
import 'package:alerta_lima/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        ChangeNotifierProvider(create: (_)=>ProfileViewmodel()),
        ],
      child: MaterialApp(
        title: 'Alerta Lima',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        localizationsDelegates: const[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: '/', // Empieza con SosScreen
        routes: {
          '/': (context) => const SosScreen(), // Pantalla inicial
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const HomeScreen(),
          '/forgot': (context) => const ForgotPasswordScreen(),
          '/chat': (context) => const ChatScreen(),
          '/sos': (context) => ChangeNotifierProvider(
            create: (_) => SOSViewModel(),
            child: const SosScreen(isEnabled: false),
          ),
          '/perfil':(context) => const ProfileScreen(),
        },
      ),
    );
  }
}
