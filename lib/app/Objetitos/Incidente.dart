import 'package:alerta_lima/app/Objetitos/usuario.dart';

class Incidente {
  final String tipo;
  final String descripcion;
  final DateTime fechaHora;
  final String ubicacion;
  final List<String>? imagenes; // URLs de imágenes
  final List<String>? video;    // URLs de videos
  final String? audio;          // URL de audio
  final Usuario usuario;

  Incidente({
    required this.tipo,
    required this.descripcion,
    required this.fechaHora,
    required this.ubicacion,
    this.imagenes,
    this.audio,
    this.video,
    required this.usuario,
  }) {
    final noHayImagenes = imagenes == null || imagenes?.isEmpty == true;
    final noHayAudio = audio == null || audio?.isEmpty == true;
    final noHayVideo = video == null || video?.isEmpty == true;

    if (noHayImagenes && noHayVideo && noHayAudio) {
      throw ArgumentError(
        'Debe adjuntarse al menos una imagen, audio o video.',
      );
    }
  }
}
