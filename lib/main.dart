import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/view/login_screen.dart';
import 'features/auth/view/register_screen.dart';
import 'features/sos/view/sos_screen.dart';
import 'features/sos/viewmodel/sos_viewmodel.dart';
import 'package:alerta_lima/features/chat/view/chat_screen.dart';
import 'package:alerta_lima/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:alerta_lima/features/profile/view/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/profile/Model/profile_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AlertaLimaApp());
}

class AlertaLimaApp extends StatelessWidget {
  const AlertaLimaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SOSViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewmodel(ProfileRepository())),
        ],
      child: MaterialApp(
        title: 'Alerta Lima',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        navigatorKey:navigatorKey,
        initialRoute: '/', // Empieza con SosScreen

        routes: {
          '/': (context) => const SosScreen(mostrar: true),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/chat': (context) => ChatScreen(),       
          '/perfil':(context) => const ProfileScreen(), 

        },
      ),
    );
  }
}
