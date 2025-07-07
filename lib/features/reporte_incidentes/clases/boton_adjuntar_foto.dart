import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alerta_lima/app/widgets/app_button2.dart';
import 'package:alerta_lima/app/widgets/app_alert_card_pop_up.dart';

class BotonAdjuntoFoto extends StatelessWidget {
  final List<File> imagenes; // Lista actual de imágenes seleccionadas
  final Function(List<File>)
  onImagenesSeleccionadas; // Función para actualizar la lista de imágenes

  const BotonAdjuntoFoto({
    super.key,
    required this.imagenes,
    required this.onImagenesSeleccionadas,
  });

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker =
        ImagePicker(); // Instancia para seleccionar imágenes

    return BotonAdjuntoNuevo(
      titulo: 'Agregar foto',
      // Subtítulo cambia dinámicamente según si hay imágenes o no
      subtitulo: imagenes.isNotEmpty
          ? '${imagenes.length} foto(s) agregadas'
          : 'Presione para tomar o cargar foto',
      icono: Icons.image,
      // Acción al hacer tap sobre el botón
      onTap: () async {
        mostrarOpcionesBottomSheet(
          context: context,
          opciones: [
            {
              'icono': Icons.camera_alt,
              'titulo': 'Tomar foto',
              'accion': () async {
                // Abre la cámara y espera a que se tome una foto
                final img = await picker.pickImage(source: ImageSource.camera);
                if (img != null) {
                  // Si se toma una foto, se actualiza la lista con la nueva imagen
                  onImagenesSeleccionadas([...imagenes, File(img.path)]);
                }
              },
            },
            {
              'icono': Icons.photo_library,
              'titulo': 'Seleccionar de galería',
              'accion': () async {
                // Abre la galería para seleccionar múltiples imágenes
                final seleccionadas = await picker.pickMultiImage();
                // Convierte cada imagen seleccionada en un File
                final nuevas = seleccionadas.map((x) => File(x.path)).toList();
                // Se actualiza la lista de imágenes con las nuevas seleccionadas
                onImagenesSeleccionadas([...imagenes, ...nuevas]);
              },
            },
          ],
        );
      },
    );
  }
}
