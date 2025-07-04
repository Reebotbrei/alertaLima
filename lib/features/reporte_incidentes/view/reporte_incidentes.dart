import 'dart:io';
import 'package:flutter/material.dart';
import 'package:alerta_lima/app/widgets/app_text_field.dart';
import 'package:alerta_lima/app/widgets/app_button.dart';
import 'package:alerta_lima/app/widgets/app_combo_box.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/audio_helper.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/boton_adjuntar_audio.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/boton_adjuntar_foto.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/boton_adjuntar_video.dart';

class Reporteincidentes extends StatefulWidget {
  const Reporteincidentes({super.key});

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
              onChanged: (value) {},
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

            // Botón de Audio
            BotonAdjuntoAudio(
              audioHelper:
                  _audioHelper, // helper que maneja la logica de la grabacion
              archivoAudioLocal:
                  _archivoAudioLocal, //archivos de audio para cargar de almacenamineto
              onAudioSeleccionado: (nuevoArchivo) {
                //actualiza el audio cargado
                _archivoAudioLocal = nuevoArchivo;
              },
              onActualizar: () => setState(() {}), //refresca la vista
            ),

            SizedBox(height: 8),

            // Botón de Fotos tomar o almacenamiento
            BotonAdjuntoFoto(
              imagenes: _imagenes, //lista actual de imagene seleccionados
              onImagenesSeleccionadas: (nuevasImagenes) {
                //callback qu actualiza  la lista con nuevas imagens
                setState(() {
                  _imagenes = nuevasImagenes;
                });
              },
            ),

            SizedBox(height: 8),

            // Botón de Videos
            BotonAdjuntoVideo(
              videos: _videos, // Lista actual de videos seleccionados
              onVideosSeleccionados: (nuevosVideos) {
                //actualiza la lista de videos
                setState(() {
                  _videos = nuevosVideos;
                });
              },
            ),

            const SizedBox(height: 80),

            // Botón Final
            AppButton(
              label: 'Enviar reporte',
              onPressed: () {
                print('Botón presionado');
              },
            ),
          ],
        ),
      ),
    );
  }
}
