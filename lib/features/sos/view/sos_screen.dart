import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../viewmodel/sos_viewmodel.dart';
import '../model/emergency_contact.dart';

class SosScreen extends StatelessWidget {
  final bool isEnabled;
  const SosScreen({super.key, this.isEnabled = true});

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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isEnabled ? ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.button,
            foregroundColor: AppColors.buttonText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          child: const Text('Login', style: TextStyle(fontSize: 21)),
        ) : null,
      ),
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
