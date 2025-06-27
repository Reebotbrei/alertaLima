import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/sos/view/sos_screen.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'menu_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final Usuario user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/perfil');
            },
          ),
        ],
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
                    Navigator.pushNamed(context, '/report');
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
                    Navigator.pushNamed(context, '/chat');
                  },
                ),
                MenuCard(
                  icon: Icons.chat,
                  title: 'Chat Vecinal',
                  onTap: () {
                    if (user.empadronado == false) {
                    } else {
                      
                    }
                  },
                ),
                MenuCard(
                  icon: Icons.phone,
                  title: 'SOS',
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute( builder: (context) => SosScreen(mostrar: false)));
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(            
            backgroundColor: AppColors.button,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/sos');
            },
            child: Text('SOS', style: const TextStyle(fontSize:20,fontWeight:  FontWeight.w800)),
            
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
          child: const Center(child:  Text(
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
