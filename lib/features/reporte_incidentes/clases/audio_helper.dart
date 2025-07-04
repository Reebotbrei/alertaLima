import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AudioHelper {
  final FlutterSoundRecorder _recorder =
      FlutterSoundRecorder(); //intancia del grabador
  bool estaGrabando = false; //indica si esta grambando actualmente
  String? rutaAudio; //variaable para la ruta del audio

  //metodo para pedir permiso e inicializar el grbador
  Future<void> inicializar() async {
    // Pedir permiso de micrófono
    var status = await Permission.microphone.request();
    //si el permiso fue denegado lanza una adventencia
    if (status != PermissionStatus.granted) {
      throw Exception('Permiso de micrófono denegado');
    }
    //abre el grabador para su uso
    await _recorder.openRecorder();
  }

  // metodo para cerrar el grabador
  Future<void> cerrar() async {
    await _recorder.closeRecorder();
  }

  //metodo para alternar entre iniciar y detener grabacion
  Future<void> grabarAudio() async {
    // Si no está grabando, comienza una nueva grabación
    if (!_recorder.isRecording) {
      Directory appDir = await getApplicationDocumentsDirectory();
      // Genera una ruta única para guardar el archivo de audio
      String path =
          '${appDir.path}/grabacion_${DateTime.now().millisecondsSinceEpoch}.aac';
      // Inicia la grabación en esa ruta usando el códec AAC
      await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);
      estaGrabando = true; //actualiza estados
      rutaAudio = path;
    } else {
      // Si ya está grabando, la detiene y guarda la ruta
      rutaAudio = await _recorder.stopRecorder();
      estaGrabando = false;
    }
  }
}
