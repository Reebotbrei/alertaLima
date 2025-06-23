import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/emergency_contact.dart';

class SOSViewModel extends ChangeNotifier {
  final List<EmergencyContact> contacts = [
    EmergencyContact(title: 'SAMU', number: '106', icon: Icons.medical_services),
    EmergencyContact(title: 'Bombero', number: '116', icon: Icons.fire_truck),
    EmergencyContact(title: 'Policía Nacional del Perú (PNP)', number: '105', icon: Icons.local_police),
    EmergencyContact(title: 'Defensa Civil', number: '115', icon: Icons.shield),
    EmergencyContact(title: 'Elias', number: '927073539', icon: Icons.person),
  ];

  Future<void> callNumber(BuildContext context, String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
        if (!launched) {
          _showErrorSnackbar(context, 'No se pudo abrir el marcador para $number');
        }
      } else {
        _showErrorSnackbar(context, 'Este dispositivo no puede manejar llamadas.');
      }
    } catch (e) {
      debugPrint('Error al llamar: $e');
      _showErrorSnackbar(context, 'Error al intentar llamar a $number');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
