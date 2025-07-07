import 'dart:io';
import 'package:alerta_lima/app/Objetitos/usuario.dart'; //se importa para pode usar file

class Incidente {
  final String tipo;
  final String descripcion;
  final DateTime fechaHora;
  final String ubicacion;
  final List<File>? imagenes;
  final List<File>? video;
  final File? audio;
  final Usuario usuario;

  Incidente({
    required this.tipo,
    required this.descripcion,
    required this.fechaHora, // ← corregido
    required this.ubicacion,
    this.imagenes,
    this.audio,
    this.video,
    required this.usuario,
  }) {
    final noHayImagenes = imagenes == null || imagenes!.isEmpty;
    final noHayAudio = audio == null;
    final noHayVideo = video == null;

    if (noHayImagenes && noHayVideo && noHayAudio) {
      throw ArgumentError(
        'Debe adjuntarse al menos una imagen, audio o video.',
      );
    }
  }
}
