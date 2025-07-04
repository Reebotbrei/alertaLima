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
      // Detecta el gesto de toque y ejecuta la función proporcionada
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
        ), // Margen inferior entre botones
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ), // Espaciado interno
        decoration: BoxDecoration(
          color: Colors.grey[100], // Color de fondo del botón
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
          border: Border.all(
            color: Colors.grey.shade300,
          ), // Borde con color gris claro
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alineación a la izquierda
                children: [
                  // Título del botón
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4), // Espacio entre título y subtítulo
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

/* SE INVOCA ASI

BotonAdjuntoNuevo(
  titulo: 'Agregar foto',
  subtitulo: 'Presione para tomar o cargar una foto',
  icono: Icons.image,
  onTap: () {
    // Acción al presionar el botón

  },
),


 */
