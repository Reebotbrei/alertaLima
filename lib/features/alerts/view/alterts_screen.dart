import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/cajita_para_mensaje.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/mis_mensajes.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/sus_mensajes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AltertsScreen extends StatelessWidget {
  final Usuario usuario;
  AltertsScreen({super.key, required this.usuario});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alertas en ${usuario.distrito}")),
      body: SafeArea(child: _AltertsView()),
    );
  }
}

class _AltertsView extends StatelessWidget {
  _AltertsView();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(child: _buildReportestList()),
          ],
        ),
      ),
    );
  }

  Widget _buildReportestList() {
    return StreamBuilder(
      stream: getReportes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Ocurrió un Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _cardsReportes(doc, context))
              .toList(),
        );
      },
    );
  }

  Stream<QuerySnapshot> getReportes() {
    return _firestore
        .collection("reportes_incidentes")
        .orderBy("fechaHora", descending: false)
        .snapshots();
  }

Widget _cardsReportes(DocumentSnapshot doc, BuildContext context) { 
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Card(
      child: ListTile(
        title: Text(data['usuario']['nombre'] ?? 'Sin título'),
        subtitle: Column( 
          children: [
            Text(data['descripcion'].length > 15 ? 
            '${data['descripcion'].substring(0, 15)}...' : 
            data['descripcion'] ?? 'Sin descripción'),
            SizedBox(height: 15),
            Image.network(data['imagenes'][0] ?? 'https://via.placeholder.com/150',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ]
        ),
        trailing: Text(
          data['fechaHora']?.toDate().toString() ?? 'Fecha no disponible',
        ),
   /*     onTap: () {
          showDialog(
            context: context,
            builder: (context) {
                return AlertDialog(
                  title: Text(data['usuario']['nombre'] ?? 'Sin título'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['descripcion'] ?? 'Sin descripción'),
                      Image.network(
                        data['imagenes'][0] ?? 'https://via.placeholder.com/150',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                );
            },
          );
        },*/
      ),
    );
  }
}

