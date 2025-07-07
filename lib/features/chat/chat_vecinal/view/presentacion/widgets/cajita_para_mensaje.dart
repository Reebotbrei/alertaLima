import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/chat/chat_vecinal_services.dart';
import 'package:flutter/material.dart';

class CajitaParaMensaje extends StatelessWidget {
  final Usuario usuario;
  CajitaParaMensaje({super.key, required this.usuario});

  final textoControlador = TextEditingController();
  final ChatVecinalServices _chatServices = ChatVecinalServices();

  @override
  Widget build(BuildContext context) {
    final foco = FocusNode();

    final outlineInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
      borderRadius: BorderRadius.circular(20),
    );

    final decoracion = InputDecoration(
      hintText: "Di lo que piensas",
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: false,
      suffixIcon: IconButton(
        icon: Icon(Icons.send_outlined),
        onPressed: () {
          sendMessage();
          textoControlador.clear();
        },
      ),
    );

    return TextFormField(
      onTapOutside: (event) {
        foco.unfocus();
      },
      focusNode: foco,
      controller: textoControlador,
      decoration: decoracion,
      onFieldSubmitted: (value) {
        textoControlador.clear();
        foco.requestFocus();
      },
    );
  }

  void sendMessage() async {
    if (textoControlador.text.isNotEmpty) {
      await _chatServices.sendMessages(usuario, textoControlador.text);
    }
  }
}
