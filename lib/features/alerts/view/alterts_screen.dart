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
      body: SafeArea(child: ListView()),
    );
  }
/*
Stream<QuerySnapshot> getReportes() {
    return _firestore
    .collection("Reporte") ;
  }*/
}
