import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../viewmodel/sos_viewmodel.dart';
import '../model/emergency_contact.dart';

class SosScreen extends StatelessWidget {
  final bool mostrar;
  const SosScreen({super.key, required this.mostrar});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SOSViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Líneas de Emergencia',
          style: TextStyle(color: AppColors.background),
        ),
      ),
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: viewModel.contacts.length,
        itemBuilder: (context, index) {
          final contact = viewModel.contacts[index];
          return EmergencyCard(
            contact: contact,
            onCall: () => viewModel.callNumber(contact.number, context),
          );
        },
      ),
      bottomNavigationBar: mostrar
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(150, 37, 154, 80),
                  foregroundColor: AppColors.buttonText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('Log in', style: TextStyle(fontSize: 20)),
              ),
            )
          : null,
    );
  }
}

class EmergencyCard extends StatelessWidget {
  final EmergencyContact contact;
  final VoidCallback onCall;

  const EmergencyCard({super.key, required this.contact, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: AppColors.background,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.border,
          child: Icon(contact.icon, color: AppColors.primary),
        ),
        title: Text(
          contact.title,
          style: const TextStyle(color: AppColors.text),
        ),
        subtitle: Text(
          contact.number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        onTap: onCall,
      ),
    );
  }
}
