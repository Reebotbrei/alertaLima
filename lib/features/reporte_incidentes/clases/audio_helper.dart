import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioHelper {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool estaGrabando = false;
  String? rutaAudio;

  Future<void> inicializar() async {
    await _recorder.openRecorder();
  }

  Future<void> cerrar() async {
    await _recorder.closeRecorder();
  }

  Future<void> grabarAudio() async {
    if (!_recorder.isRecording) {
      // Obtener una ruta externa visible
      Directory? externalDir =
          await getExternalStorageDirectory(); // Necesitas importar path_provider
      String path =
          '${externalDir!.path}/grabacion_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);
      estaGrabando = true;
      rutaAudio = path;
    } else {
      rutaAudio = await _recorder.stopRecorder();
      estaGrabando = false;
    }
  }
}
