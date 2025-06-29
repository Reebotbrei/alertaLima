import 'package:flutter/material.dart';

class CajitaParaMensaje extends StatelessWidget {
  const CajitaParaMensaje({super.key});

  @override
  Widget build(BuildContext context) {
    final textoControlador = TextEditingController();
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
          final texto = textoControlador.value.text;
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
}
