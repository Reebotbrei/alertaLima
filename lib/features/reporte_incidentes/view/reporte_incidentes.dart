import 'package:flutter/material.dart';
import 'package:alerta_lima/app/widgets/app_text_field.dart';
import 'package:alerta_lima/app/widgets/app_button2.dart';
import 'package:alerta_lima/app/widgets/app_button.dart';
import 'package:alerta_lima/app/widgets/app_combo_box.dart';
import 'package:alerta_lima/features/reporte_incidentes/clases/audio_helper.dart';
import 'dart:io'; // Para usar File
import 'package:image_picker/image_picker.dart'; // Para usar ImagePicker

class Reporteincidentes extends StatefulWidget {
  const Reporteincidentes({super.key});

  @override
  State<Reporteincidentes> createState() => _ReporteincidentesState();
}

class _ReporteincidentesState extends State<Reporteincidentes> {
  final TextEditingController _numeroController = TextEditingController();

  //
  final AudioHelper _audioHelper = AudioHelper();
  final ImagePicker _picker = ImagePicker(); // Instancia del selector
  File? _image; // Para guardar la foto
  File? _video; // Para guardar el video

  @override
  void initState() {
    super.initState();
    _audioHelper.inicializar(); // Inicializa el grabador
  }

  @override
  void dispose() {
    _audioHelper.cerrar(); // Libera recursos del micrófono
    super.dispose();
  }

  //la fecha y los datos de ukbicaion  los vamos ha tomar de manera autaomatica
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Evita que la pantalla se redimensione
      appBar: AppBar(
        title: const Text('Reportar Incidente'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              //encabezado del combo box
              alignment: Alignment.centerLeft,
              child: Text("Seleccione", style: TextStyle(fontSize: 20)),
            ),
            //invocamos al combo box
            DropdownTextField(
              hintText: 'Selecciona una opción',
              //lista de opciones del combobox
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

            SizedBox(height: 8), // Espacio de 8 píxeles
            //encabezado de detalle
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Detalle del incidente",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 8), // Espacio de 8 píxeles
            //caja de texto para agregar descripcion proviene de app_text_field
            AppTextField(
              controller: _numeroController,
              hintText: 'breve descripción',
              keyboardType: TextInputType.text,
              maxLines: 3,
            ),
            SizedBox(height: 8),
            //evcabezado
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Adjuntar", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 8), // Espacio de 8 píxeles

            SizedBox(height: 8),
            //boton para adjuntar audio proviene de app_button2
            BotonAdjuntoNuevo(
              titulo: 'Agregar audio',
              subtitulo: _audioHelper.estaGrabando
                  ? 'Grabando...'
                  : (_audioHelper.rutaAudio != null
                        ? 'Audio grabado'
                        : 'Presione para iniciar'),
              icono: Icons.mic,
              onTap: () async {
                await _audioHelper.grabarAudio();
                setState(() {}); // Refresca para mostrar el nuevo estado
              },
            ),

            SizedBox(height: 8),
            //boton para adjuntar fotos proviene de app_button2
            BotonAdjuntoNuevo(
              titulo: 'Agregar foto',
              subtitulo: _image != null
                  ? 'Foto agregada'
                  : 'Presione para tomar o cargar foto',
              icono: Icons.image,
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Tomar foto'),
                        onTap: () async {
                          final img = await _picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (img != null) {
                            setState(() => _image = File(img.path));
                          }
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Seleccionar de galería'),
                        onTap: () async {
                          final img = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (img != null) {
                            setState(() => _image = File(img.path));
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 8),
            //boton para adjuntar video proviene de app_button2
            BotonAdjuntoNuevo(
              titulo: 'Agregar video',
              subtitulo: _video != null
                  ? 'Video agregado'
                  : 'Presione para cargar o agregar video',
              icono: Icons.videocam,
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.videocam),
                        title: Text('Grabar video'),
                        onTap: () async {
                          final vid = await _picker.pickVideo(
                            source: ImageSource.camera,
                          );
                          if (vid != null) {
                            setState(() => _video = File(vid.path));
                          }
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Subir desde galería'),
                        onTap: () async {
                          final vid = await _picker.pickVideo(
                            source: ImageSource.gallery,
                          );
                          if (vid != null) {
                            setState(() => _video = File(vid.path));
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 80),

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
