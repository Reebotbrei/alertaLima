import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'menu_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
}
