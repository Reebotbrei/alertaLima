import 'package:flutter/material.dart';

class BotonAdjuntoNuevo extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final VoidCallback onTap;

  const BotonAdjuntoNuevo({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(icono, size: 24, color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }
}
