import 'dart:io';

import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/cajita_para_mensaje.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/mis_mensajes.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/widgets/sus_mensajes.dart';
import 'package:flutter/material.dart';

class ChatVecinalScreen extends StatelessWidget {
  final String nombreVecindad;
  const ChatVecinalScreen({super.key, this.nombreVecindad = "nada"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nombreVecindad,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: false,
      ),
      body: _ChatVecinalView(),
    );
  }
}

class _ChatVecinalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return index%2 == 0 ? MisMensajes() : SusMensajes(nombre: "Nepta");
                },
              ),
            ),
            CajitaParaMensaje(),
          ],
        ),
      ),
    );
  }
}
