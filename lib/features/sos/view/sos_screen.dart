import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_button.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_EmergencyContact> contacts = [
      _EmergencyContact('SAMU', '106', Icons.medical_services),
      _EmergencyContact('Bomberos', '116', Icons.fire_truck),
      _EmergencyContact('Policía Nacional', '105', Icons.local_police),
      _EmergencyContact('Defensa Civil', '115', Icons.shield),
      _EmergencyContact('Elias', '927 073 539', Icons.person),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Líneas de Emergencia'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Icon(contact.icon, color: AppColors.primary),
                      ),
                      title: Text(
                        contact.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        contact.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.text,
                        ),
                      ),
                      onTap: () async {
                        final Uri uri = Uri(scheme: 'tel', path: contact.number);
                        try {
                          final bool launched = await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                          if (!launched) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No se pudo iniciar la llamada'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al intentar llamar: $e'),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Login',
              onPressed: () {
                // TODO: Agregar navegación a pantalla de login
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyContact {
  final String name;
  final String number;
  final IconData icon;

  _EmergencyContact(this.name, this.number, this.icon);
}
