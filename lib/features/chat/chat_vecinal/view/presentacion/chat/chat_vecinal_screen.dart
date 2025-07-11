import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/cajita_para_mensaje.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/mis_mensajes.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/sus_mensajes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatVecinalScreen extends StatelessWidget {
  final Usuario usuario;
  const ChatVecinalScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          usuario.vecindario.toString(),
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: false,
      ),
      endDrawer: null,
      body: _ChatVecinalView(usuario),
    );
  }
}

class _ChatVecinalView extends StatelessWidget {
  final Usuario usuario;
  _ChatVecinalView(this.usuario);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(child: _buildMessageList()),
            CajitaParaMensaje(usuario : usuario),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: getMessage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Ocurrió un Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _globosMensaje(doc))
              .toList(),
        );
      },
    );
  }

  Stream<QuerySnapshot> getMessage() {
    return _firestore
        .collection("Distritos")
        .doc(usuario.distrito)
        .collection("Vecindarios")
        .doc(usuario.vecindario)
        .collection("Messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  Widget _globosMensaje(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool usuarioActual = data['autorID'] == usuario.id;
    return usuarioActual ? MisMensajes(mensaje: data["message"],) : SusMensajes(nombre: data["autorNombre"], mensaje: data["message"],);
  }

}
