import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/chat/view/chat_screen.dart';
import 'package:alerta_lima/features/sos/view/sos_screen.dart';
import '../../../app/theme/app_colors.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'menu_card.dart';

import '../../auth/view/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final Usuario usuario;
  const HomeScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Inicio'),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Cabecera del Drawer con la información del usuario
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: usuario.imageUrl != null && usuario.imageUrl!.isNotEmpty
                          ? NetworkImage(usuario.imageUrl!) as ImageProvider<Object>?
                          : null,
                      child: (usuario.imageUrl == null || usuario.imageUrl!.isEmpty)
                          ? const Icon(Icons.person, size: 30, color: AppColors.primary)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      usuario.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      usuario.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Mi Perfil'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  Navigator.pushNamed(context, '/perfil'); // Navega a la pantalla de perfil
                },
              ),
              const Divider(), // Divisor para separar el perfil de cerrar sesión
              
              // Botón para "Cerrar Sesión"
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.error)),
                onTap: () async {
                  Navigator.pop(context); // Cierra el drawer inmediatamente

                  // Cerramos sesión
                  try {
                    await firebase_auth.FirebaseAuth.instance.signOut();
                    // Después de cerrar sesión, navega a la pantalla de login y elimina todas las rutas anteriores
                    if (context.mounted) { 
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    // Manejo de errores si el cierre de sesión falla
                    if(context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al cerrar sesión: $e')),
                    );
                    }
                  }
                },
              ),
            ],
          ),
        ),
        body: Consumer<DashboardViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                MenuCard(
                  icon: Icons.warning_amber_rounded,
                  title: 'Reportar Incidente',
                  onTap: () {
                    if (usuario.empadronado == false) {
                      _mensajeEnable(context);
                    } else {
                      Navigator.pushNamed(context, '/report');
                    }
                  },
                ),
                MenuCard(
                  icon: Icons.campaign_outlined,
                  title: 'Alertas en tu zona',
                  onTap: () {
                    Navigator.pushNamed(context, '/alerts');
                  },
                ),
                MenuCard(
                  icon: Icons.map_outlined,
                  title: 'Mapa de Seguridad',
                  onTap: () {
                    Navigator.pushNamed(context, '/map');
                  },
                ),
                MenuCard(
                  icon: Icons.support_agent,
                  title: 'Contactar Autoridad',
                  onTap: () {
                    if (usuario.empadronado == false) {
                      _mensajeEnable(context);
                    } else {
                      Navigator.pushNamed(context, '/chat');
                    }
                  },
                ),
                MenuCard(
                  icon: Icons.chat,
                  title: 'Chat Vecinal',
                  onTap: () {
                    if (usuario.empadronado == false) {
                      _mensajeEnable(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    }
                  },
                ),
                MenuCard(
                  icon: Icons.phone,
                  title: 'SOS',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SosScreen(mostrar: false),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //usar para empadronamiento
  void _mensajeEnable(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.all(16),
            color: const Color.fromARGB(212, 8, 160, 79),
            child: const Center(
              child: Text(
                "Ups!, Algo salió mal",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          content: SizedBox(
            width: 300, //ancho
            height: 95, //alto
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Debes estar empadronado para acceder a esta función",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
