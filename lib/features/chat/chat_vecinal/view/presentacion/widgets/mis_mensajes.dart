import 'package:flutter/material.dart';
import 'package:alerta_lima/app/theme/app_colors.dart';

class MisMensajes extends StatelessWidget {
  final String mensaje;

  const MisMensajes({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    final Color colors = AppColors.paraMiMensaje;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: mensaje.length > 31 ? 315 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: colors,
          ),
          child: Padding(
            //Espacio entre el inicio del mensaje y el incio del globito
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(mensaje, style: TextStyle(color: Colors.black)),
          ),  
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
