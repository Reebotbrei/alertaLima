import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:alerta_lima/app/widgets/app_alert_card.dart';
import 'package:alerta_lima/app/widgets/app_button2.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/audio_helper.dart';
import 'package:alerta_lima/app/widgets/app_alert_card_pop_up.dart';

//permite al usuario  agregar audio

class BotonAdjuntoAudio extends StatelessWidget {
  final AudioHelper audioHelper;
  final File? archivoAudioLocal;
  final Function(File?) onAudioSeleccionado;
  final Function() onActualizar;
  final String? subtitulo;

  const BotonAdjuntoAudio({
    super.key,
    required this.audioHelper,
    required this.archivoAudioLocal,
    required this.onAudioSeleccionado,
    required this.onActualizar,
    this.subtitulo,
  });

  // Método para seleccionar un archivo de audio desde el almacenamiento
  Future<void> _seleccionarAudioDesdeArchivos(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
    );
    // Si el usuario seleccionó un archivo correctamente
    if (result != null && result.files.single.path != null) {
      onAudioSeleccionado(File(result.files.single.path!));
      onActualizar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BotonAdjuntoNuevo(
      titulo: 'Agregar audio',
      subtitulo: subtitulo ?? (audioHelper.estaGrabando
          ? 'Grabando...'
          : (audioHelper.rutaAudio != null || archivoAudioLocal != null)
              ? 'Audio grabado'
              : 'Presione para grabar o cargar'),
      icono: Icons.mic,
      onTap: () {
        mostrarOpcionesBottomSheet(
          context: context,
          opciones: [
            {
              'titulo': 'Grabar audio',
              'icono': Icons.mic,
              'accion': () async {
                await audioHelper
                    .grabarAudio(); // Comienza o detiene la grabación
                onActualizar(); // Actualiza el estado para reflejar cambios
                // Si se está grabando, muestra una alerta tipo pop-up
                if (audioHelper.estaGrabando) {
                  AppAlertCard.show(
                    context: context,
                    title: 'Grabando audio',
                    message: 'Se está grabando el audio...',
                    primaryButtonText: 'Detener',
                    // Si el usuario presiona "Detener", se vuelve a llamar a grabarAudio()
                    onPrimaryPressed: () async {
                      await audioHelper.grabarAudio(); // Detiene la grabación
                      onActualizar();
                    },
                  );
                }
              },
            },
            {
              'titulo': 'Seleccionar desde archivos',
              'icono': Icons.library_music,
              'accion': () async {
                await _seleccionarAudioDesdeArchivos(context);
              },
            },
          ],
        );
      },
    );
  }
}
