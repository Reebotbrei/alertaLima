import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:alerta_lima/app/Objetitos/Incidente.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alerta_lima/app/widgets/app_text_field.dart';
import 'package:alerta_lima/app/widgets/app_button.dart';
import 'package:alerta_lima/app/widgets/app_combo_box.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/audio_helper.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/boton_adjuntar_audio.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/boton_adjuntar_foto.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/boton_adjuntar_video.dart';
import 'package:alerta_lima/features/map/clasesMaps/obtener_ubicacion_actual.dart';
import 'package:alerta_lima/app/Objetitos/usuario.dart';

class Reporteincidentes extends StatefulWidget {
  //para recivir el ususario
  final Usuario usuario;
  const Reporteincidentes({super.key, required this.usuario});

  @override
  State<Reporteincidentes> createState() => _ReporteincidentesState();
}

class _ReporteincidentesState extends State<Reporteincidentes> {
  // Controlador para el campo de texto de descripción
  final TextEditingController _numeroController = TextEditingController();
  //intanciacion de la calse helper  para grabar audio
  final AudioHelper _audioHelper = AudioHelper();
  //variables para almacenar archivos seleccionados
  List<File> _imagenes = [];
  List<File> _videos = [];
  File? _archivoAudioLocal;

  // Copia un archivo a una ruta persistente y retorna el nuevo File
  Future<File> _copiarAStoragePersistente(File archivo, String subcarpeta) async {
    final dir = await getApplicationDocumentsDirectory();
    final carpeta = Directory('${dir.path}/$subcarpeta');
    if (!await carpeta.exists()) {
      await carpeta.create(recursive: true);
    }
    final nombreArchivo = '${DateTime.now().millisecondsSinceEpoch}_${archivo.path.split(Platform.pathSeparator).last}';
    final nuevoPath = '${carpeta.path}/$nombreArchivo';
    final nuevoArchivo = await archivo.copy(nuevoPath);
    return nuevoArchivo;
  }
  //variable para guardar el tipo de incidente
  String? _tipoSeleccionado;

  @override
  void initState() {
    super.initState();
    _audioHelper.inicializar(); //inicializar el grabador de audio
  }

  @override
  void dispose() {
    _audioHelper.cerrar(); //liberar recursos de microfono
    super.dispose();
  }



  // Formatea bytes a string legible (ej: 1.2 MB)
  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes == 0) ? 0 : (log(bytes) / log(1024)).floor();
    double size = bytes / pow(1024, i);
    return size.toStringAsFixed(decimals) + ' ' + suffixes[i];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, //evita redimentcionar al abrir el teclado
      appBar: AppBar(
        title: const Text('Reportar Incidente'),
        centerTitle: true,
      ),
      //body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ComboBox
            //encabezado de witget combo box
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Seleccione", style: TextStyle(fontSize: 20)),
            ),
            // ComboBox para elegir tipo de incidente
            DropdownTextField(
              hintText: 'Selecciona una opción',
              options: [
                'Robo',
                'Hurto',
                'Extorsión',
                'Estafa',
                'Violación sexual',
                'Homicidio',
                'Lesiones',
                'Acoso',
                'Tráfico de drogas',
                'Violencia familiar',
                'Conducción en estado de ebriedad',
                'Secuestro',
                'Ciberacoso',
                'Suplantación de identidad',
                'Maltrato infantil',
              ],
              onChanged: (value) {
                setState(() {
                  //guardamos el la variable el tipo de incidnete seleccionado
                  _tipoSeleccionado = value;
                });
              },
            ),
            SizedBox(height: 8),

            // Detalle del incidente
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Detalle del incidente",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 8),
            AppTextField(
              controller: _numeroController,
              hintText: 'Breve descripción',
              keyboardType: TextInputType.text,
              maxLines: 3,
            ),

            SizedBox(height: 16),
            //encabezado de adjuntar
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Adjuntar", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 8),

            // Botón de Audio (muestra tamaño si existe)
            BotonAdjuntoAudio(
              audioHelper: _audioHelper,
              archivoAudioLocal: _archivoAudioLocal,
              subtitulo: _archivoAudioLocal != null && _archivoAudioLocal!.existsSync()
                  ? 'Audio grabado (' + _formatBytes(_archivoAudioLocal!.lengthSync()) + ')'
                  : null,
              onAudioSeleccionado: (nuevoArchivo) async {
                if (nuevoArchivo != null) {
                  final persistente = await _copiarAStoragePersistente(nuevoArchivo, 'audios');
                  setState(() {
                    _archivoAudioLocal = persistente;
                  });
                }
              },
              onActualizar: () async {
                // Si hay audio grabado en audioHelper.rutaAudio y no está en _archivoAudioLocal, lo asigna
                if (_audioHelper.rutaAudio != null) {
                  final file = File(_audioHelper.rutaAudio!);
                  if (await file.exists()) {
                    final persistente = await _copiarAStoragePersistente(file, 'audios');
                    setState(() {
                      _archivoAudioLocal = persistente;
                    });
                  }
                } else {
                  setState(() {});
                }
              },
            ),

            SizedBox(height: 8),

            // Botón de Fotos tomar o almacenamiento (muestra cantidad y tamaño)
            BotonAdjuntoFoto(
              imagenes: _imagenes,
              subtitulo: _imagenes.isNotEmpty
                  ? '${_imagenes.length} foto(s) agregadas (' + _formatBytes(_imagenes.fold<int>(0, (p, f) => p + (f.existsSync() ? f.lengthSync() : 0))) + ')'
                  : 'Presione para tomar o cargar foto',
              onImagenesSeleccionadas: (nuevasImagenes) async {
                List<File> persistentes = [];
                for (var img in nuevasImagenes) {
                  final persistente = await _copiarAStoragePersistente(img, 'imagenes');
                  persistentes.add(persistente);
                }
                setState(() {
                  _imagenes = persistentes;
                });
              },
            ),

            SizedBox(height: 8),

            // Botón de Videos (muestra cantidad y tamaño)
            BotonAdjuntoVideo(
              videos: _videos,
              subtitulo: _videos.isNotEmpty
                  ? '${_videos.length} video(s) agregados (' + _formatBytes(_videos.fold<int>(0, (p, f) => p + (f.existsSync() ? f.lengthSync() : 0))) + ')'
                  : 'Presione para cargar o agregar video',
              onVideosSeleccionados: (nuevosVideos) async {
                List<File> persistentes = [];
                for (var vid in nuevosVideos) {
                  final persistente = await _copiarAStoragePersistente(vid, 'videos');
                  persistentes.add(persistente);
                }
                setState(() {
                  _videos = persistentes;
                });
              },
            ),
            const SizedBox(height: 80),

            // Botón Final
            AppButton(
              label: 'Enviar reporte',
              onPressed: () async {
                final ubicacion = await UbicacionHelper.obtenerUbicacion();

                if (_tipoSeleccionado == null || _numeroController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Completa todos los campos obligatorios.'),
                    ),
                  );
                  return;
                }

                // Mostrar confirmación antes de enviar
                bool? confirmar = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirmar envío'),
                    content: Text('¿Estás seguro que quieres enviar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Enviar'),
                      ),
                    ],
                  ),
                );
                if (confirmar != true) return;

                try {
                  // --- Asegura que todas las imágenes estén en storage persistente ---
                  List<File> imagenesPersistentes = [];
                  for (var img in _imagenes) {
                    if (!img.path.contains('/imagenes/') && !img.path.contains('imagenes')) {
                      final persistente = await _copiarAStoragePersistente(img, 'imagenes');
                      imagenesPersistentes.add(persistente);
                    } else {
                      imagenesPersistentes.add(img);
                    }
                  }
                  _imagenes = imagenesPersistentes;

                  // --- Asegura que todos los videos estén en storage persistente ---
                  List<File> videosPersistentes = [];
                  for (var vid in _videos) {
                    if (!vid.path.contains('/videos/') && !vid.path.contains('videos')) {
                      final persistente = await _copiarAStoragePersistente(vid, 'videos');
                      videosPersistentes.add(persistente);
                    } else {
                      videosPersistentes.add(vid);
                    }
                  }
                  _videos = videosPersistentes;

                  // Subir imágenes a Firebase Storage (manejo seguro)
                  List<String> urlsImagenes = [];
                  for (var img in _imagenes) {
                    if (!img.existsSync()) {
                      throw Exception('El archivo de imagen no existe: ${img.path}');
                    }
                    final length = await img.length();
                    if (length == 0) {
                      throw Exception('El archivo de imagen está vacío: ${img.path}');
                    }
                    String nombre = 'imagenes/${DateTime.now().millisecondsSinceEpoch}_${img.path.split(Platform.pathSeparator).last}';
                    final ref = FirebaseStorage.instance.ref().child(nombre);
                    try {
                      final uploadTask = await ref.putFile(img);
                      debugPrint('UploadTask state for ${img.path}: \\${uploadTask.state}');
                      if (uploadTask.state == TaskState.success) {
                        final url = await ref.getDownloadURL();
                        urlsImagenes.add(url);
                      } else {
                        throw Exception('No se pudo subir la imagen: ${img.path}. Estado: \\${uploadTask.state}');
                      }
                    } catch (e, stack) {
                      debugPrint('Firebase error al subir imagen: ${img.path} -> $e');
                      debugPrint('Stacktrace: $stack');
                      throw Exception('Error subiendo imagen: ${img.path} -> $e');
                    }
                  }

                  // Subir videos a Firebase Storage (manejo seguro)
                  List<String> urlsVideos = [];
                  for (var vid in _videos) {
                    if (!vid.existsSync()) {
                      throw Exception('El archivo de video no existe: ${vid.path}');
                    }
                    final length = await vid.length();
                    if (length == 0) {
                      throw Exception('El archivo de video está vacío: ${vid.path}');
                    }
                    String nombre = 'videos/${DateTime.now().millisecondsSinceEpoch}_${vid.path.split(Platform.pathSeparator).last}';
                    final ref = FirebaseStorage.instance.ref().child(nombre);
                    try {
                      final uploadTask = await ref.putFile(vid);
                      debugPrint('UploadTask state for ${vid.path}: \\${uploadTask.state}');
                      if (uploadTask.state == TaskState.success) {
                        final url = await ref.getDownloadURL();
                        urlsVideos.add(url);
                      } else {
                        throw Exception('No se pudo subir el video: ${vid.path}. Estado: \\${uploadTask.state}');
                      }
                    } catch (e, stack) {
                      debugPrint('Firebase error al subir video: ${vid.path} -> $e');
                      debugPrint('Stacktrace: $stack');
                      throw Exception('Error subiendo video: ${vid.path} -> $e');
                    }
                  }

                  // Subir audio a Firebase Storage (manejo seguro)
                  String? urlAudio;
                  if (_archivoAudioLocal != null) {
                    if (!_archivoAudioLocal!.existsSync()) {
                      throw Exception('El archivo de audio no existe: ${_archivoAudioLocal!.path}');
                    }
                    final length = await _archivoAudioLocal!.length();
                    if (length == 0) {
                      throw Exception('El archivo de audio está vacío: ${_archivoAudioLocal!.path}');
                    }
                    String nombre = 'audios/${DateTime.now().millisecondsSinceEpoch}_${_archivoAudioLocal!.path.split(Platform.pathSeparator).last}';
                    final ref = FirebaseStorage.instance.ref().child(nombre);
                    try {
                      final uploadTask = await ref.putFile(_archivoAudioLocal!);
                      debugPrint('UploadTask state for ${_archivoAudioLocal!.path}: \\${uploadTask.state}');
                      if (uploadTask.state == TaskState.success) {
                        urlAudio = await ref.getDownloadURL();
                      } else {
                        throw Exception('No se pudo subir el audio. Estado: \\${uploadTask.state}');
                      }
                    } catch (e, stack) {
                      debugPrint('Firebase error al subir audio: ${_archivoAudioLocal!.path} -> $e');
                      debugPrint('Stacktrace: $stack');
                      throw Exception('Error subiendo audio: ${_archivoAudioLocal!.path} -> $e');
                    }
                  }

                  final incidente = Incidente(
                    tipo: _tipoSeleccionado!,
                    descripcion: _numeroController.text.trim(),
                    fechaHora: DateTime.now(),
                    ubicacion: ubicacion,
                    imagenes: urlsImagenes.isEmpty ? null : urlsImagenes,
                    audio: urlAudio,
                    video: urlsVideos.isEmpty ? null : urlsVideos,
                    usuario: widget.usuario,
                  );
                  // Guardar el incidente en Firestore
                  await FirebaseFirestore.instance.collection('reportes_incidentes').add({
                    'tipo': incidente.tipo,
                    'descripcion': incidente.descripcion,
                    'fechaHora': incidente.fechaHora,
                    'ubicacion': incidente.ubicacion,
                    'imagenes': incidente.imagenes,
                    'audio': incidente.audio,
                    'video': incidente.video,
                    'usuario': {
                      'id': incidente.usuario.id,
                      'nombre': incidente.usuario.nombre,
                      // Agrega más campos si tu modelo Usuario tiene más
                    },
                  });
                  // Mostrar mensaje de éxito después de guardar
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reporte enviado con exito')),
                      );
                    }
                  });
                  // Limpiar campos
                  setState(() {
                    _imagenes = [];
                    _videos = [];
                    _archivoAudioLocal = null;
                    _numeroController.clear();
                    _tipoSeleccionado = null;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
