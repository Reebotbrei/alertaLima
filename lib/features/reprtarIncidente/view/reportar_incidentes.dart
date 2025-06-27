import 'package:flutter/material.dart';
import 'package:alerta_lima/app/widgets/app_text_field.dart';
import 'package:alerta_lima/app/widgets/app_button2.dart';
import 'package:alerta_lima/app/widgets/app_button.dart';
import 'package:alerta_lima/app/widgets/app_combo_box.dart';

class Reporteincidentes extends StatefulWidget {
  const Reporteincidentes({super.key});

  @override
  State<Reporteincidentes> createState() => _ReporteincidentesState();
}

class _ReporteincidentesState extends State<Reporteincidentes> {
  final TextEditingController _numeroController = TextEditingController();
  //la fecha y los datos de ukbicaion  los vamos ha tomar de manera autaomatica
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              keyboardType: TextInputType.phone,
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
              subtitulo: 'presione para iniciar',
              icono: Icons.mic,
              onTap: () {},
            ),

            SizedBox(height: 8),
            //boton para adjuntar fotos proviene de app_button2
            BotonAdjuntoNuevo(
              titulo: 'Agregar foto',
              subtitulo: 'precione par tomar o cargar foto',
              icono: Icons.image,
              onTap: () {},
            ),

            SizedBox(height: 8),
            //boton para adjuntar video proviene de app_button2
            BotonAdjuntoNuevo(
              titulo: 'Agregar video',
              subtitulo: 'precione para cargar o agregar video',
              icono: Icons.videocam,
              onTap: () {},
            ),

            SizedBox(height: 150),

            AppButton(
              label: 'Enviar',
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
