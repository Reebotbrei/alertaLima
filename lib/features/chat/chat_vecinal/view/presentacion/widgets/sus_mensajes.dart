import 'package:alerta_lima/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SusMensajes extends StatelessWidget {
  final String nombre;
  final String mensaje;
  const SusMensajes({super.key, required this.nombre, this.mensaje = "aeaeaeaa"});

  @override
  Widget build(BuildContext context) {
    final Color colors = AppColors.mensajeDeOtros;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  $nombre" , style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        Container(
          width: mensaje.length > 31 ? 315 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: colors,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(mensaje, style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
