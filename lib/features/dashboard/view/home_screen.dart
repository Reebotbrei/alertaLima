import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/chat/view/chat_screen.dart';
import 'package:alerta_lima/features/reporte_incidentes/view/reporte_incidentes.dart';
import 'package:alerta_lima/features/sos/view/sos_screen.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'menu_card.dart';
import 'package:provider/provider.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/chat/chat_vecinal_screen.dart';
import 'package:alerta_lima/features/map/view/pantalla_Mapa.dart';

class HomeScreen extends StatelessWidget {
  final Usuario usuario;
  const HomeScreen({super.key, required this.usuario});
  final Color colorIcono = AppColors.primary;
  final Color colorFondo = AppColors.background;
  final Color colorTexto = AppColors.text;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Inicio'), centerTitle: true),
        body: Consumer<DashboardViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                MenuCard(
                  texto: usuario.empadronado == false
                      ? const Color.fromARGB(136, 49, 46, 46)                  
                      : colorTexto,
                  fondo: usuario.empadronado == false
                      ? const Color.fromARGB(170, 251, 247, 247)
                      : colorFondo,
                  colorIcono: usuario.empadronado == false
                      ? const Color.fromARGB(99, 39, 38, 38)
                      : colorIcono,
                  icon: Icons.warning_amber_rounded,
                  title: 'Reportar Incidente',
                  onTap: () {
                    if (usuario.empadronado == false) {
                      _mensajeEnable(context);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Reporteincidentes(
                          usuario: usuario,
                        ), //invocamos al clases donde se encuntra el mapa
                      ),
                    );
                  },
                ),
                MenuCard(
                  texto: colorTexto,
                  fondo: colorFondo,
                  colorIcono: colorIcono,
                  icon: Icons.campaign_outlined,
                  title: 'Alertas en tu zona',
                  onTap: () {
                    Navigator.pushNamed(context, '/alerts');
                  },
                ),
                MenuCard(
                  texto: colorTexto,
                  fondo: colorFondo,
                  colorIcono: colorIcono,
                  icon: Icons.map_outlined,
                  title: 'Mapa de Seguridad',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            (pantallaMapa()), //invocamos al clases donde se encuntra el mapa
                      ),
                    );
                  },
                ),
                MenuCard(
                    texto: usuario.empadronado == false
                      ?   const Color.fromARGB(136, 49, 46, 46)                         
                      : colorTexto,
                  fondo: usuario.empadronado == false
                      ?  const Color.fromARGB(170, 251, 247, 247)
                      : colorFondo,
                  colorIcono: usuario.empadronado == false
                      ? const Color.fromARGB(99, 39, 38, 38)
                      : colorIcono,
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
                    texto: usuario.empadronado == false
                      ? const Color.fromARGB(136, 49, 46, 46)                    
                      : colorTexto,
                  fondo: usuario.empadronado == false
                      ? const Color.fromARGB(170, 251, 247, 247)
                      : colorFondo,
                  colorIcono: usuario.empadronado == false
                      ? const Color.fromARGB(99, 39, 38, 38)
                      : colorIcono,
                  icon: Icons.chat,
                  title: 'Chat Vecinal',
                  onTap: () {
                    if (usuario.empadronado == false) {
                      _mensajeEnable(context);
                    } else {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              ChatVecinalScreen(usuario: usuario),
                        ),
                      );
                    }
                  },
                ),
                MenuCard(
                  texto: colorTexto,
                  fondo: colorFondo,
                  colorIcono: colorIcono,
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
