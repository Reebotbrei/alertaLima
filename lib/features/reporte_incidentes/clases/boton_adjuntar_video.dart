import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:alerta_lima/app/widgets/app_alert_card_pop_up.dart'; // Asegúrate de importar tu función reutilizable
import 'package:alerta_lima/app/widgets/app_button2.dart';


class BotonAdjuntoVideo extends StatelessWidget {
  final List<File> videos;
  final Function(List<File>) onVideosSeleccionados;
  final String? subtitulo;

  const BotonAdjuntoVideo({
    super.key,
    required this.videos,
    required this.onVideosSeleccionados,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker =
        ImagePicker(); //instancia para capturar video desde la camara

    return BotonAdjuntoNuevo(
      titulo: 'Agregar video',
      subtitulo: subtitulo ?? (videos.isNotEmpty
          ? '${videos.length} video(s) agregados'
          : 'Presione para cargar o agregar video'),
      icono: Icons.videocam,
      onTap: () async {
        // Muestra un menú (bottom sheet) con dos opciones: grabar o seleccionar video
        mostrarOpcionesBottomSheet(
          context: context,
          opciones: [
            {
              'icono': Icons.videocam,
              'titulo': 'Grabar video',
              'accion': () async {
                // Captura un video usando la cámara del dispositivo
                final vid = await picker.pickVideo(source: ImageSource.camera);
                if (vid != null) {
                  // Si se graba un video exitosamente, se actualiza la lista
                  onVideosSeleccionados([...videos, File(vid.path)]);
                }
              },
            },
            {
              'icono': Icons.video_library,
              'titulo': 'Subir desde galería',
              'accion': () async {
                // Abre el explorador de archivos para seleccionar múltiples videos
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.video,
                  allowMultiple: true,
                );
                if (result != null && result.files.isNotEmpty) {
                  // Convierte los archivos seleccionados en objetos File
                  final nuevosVideos = result.files
                      .map((f) => File(f.path!))
                      .toList();
                  // Actualiza la lista con los nuevos videos
                  onVideosSeleccionados([...videos, ...nuevosVideos]);
                }
              },
            },
          ],
        );
      },
    );
  }
}
