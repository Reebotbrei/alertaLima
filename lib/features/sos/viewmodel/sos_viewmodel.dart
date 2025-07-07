import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/emergency_contact.dart';

class SOSViewModel extends ChangeNotifier {
  final List<EmergencyContact> contacts = [
    EmergencyContact(title: 'SAMU', number: '106', icon: Icons.local_hospital),
    EmergencyContact(title: 'Bomberos', number: '116', icon: Icons.fire_truck),
    EmergencyContact(
      title: 'Policía Nacional',
      number: '105',
      icon: Icons.local_police,
    ),
    EmergencyContact(title: 'Defensa Civil', number: '115', icon: Icons.shield),
    EmergencyContact(
      title: 'Elias oño',
      number: '927073539',
      icon: Icons.account_circle,
    ),
  ];

  Future<void> callNumber(String number, BuildContext context) async {
    final String cleanNumber = number.replaceAll(
      RegExp(r'\s+'),
      '',
    ); // 🔽 Quitar espacios
    final Uri uri = Uri(scheme: 'tel', path: cleanNumber);

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!context.mounted) return;
      if (!launched) {
        _showError(context, 'No se pudo realizar la llamada');
      }
    } catch (e) {
      _showError(context, 'Error al intentar llamar: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
