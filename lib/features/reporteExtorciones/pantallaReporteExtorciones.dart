import 'package:flutter/material.dart';
import 'package:alerta_lima/app/widgets/app_text_field.dart';
import 'package:alerta_lima/app/widgets/app_button2.dart';
import 'package:alerta_lima/app/widgets/app_button.dart';

class Pantallareporteextorciones extends StatefulWidget {
  const Pantallareporteextorciones({super.key});

  @override
  State<Pantallareporteextorciones> createState() =>
      _PantallareporteextorcionesState();
}

class _PantallareporteextorcionesState
    extends State<Pantallareporteextorciones> {
  final TextEditingController _numeroController = TextEditingController();
  //la fecha y los datos de ukbicaion  los vamos ha tomar de manera autaomatica
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Extorciones'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Numero", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 8), // Espacio de 8 píxeles

            AppTextField(
              controller: _numeroController,
              hintText: 'Ingresa Numero extorsionador',
              keyboardType: TextInputType.phone,
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text("Medio", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 8), // Espacio de 8 píxeles

            AppTextField(
              controller: _numeroController,
              hintText: 'medio de contacto',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text("Descripcion", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 8), // Espacio de 8 píxeles

            AppTextField(
              controller: _numeroController,
              hintText: 'breve desción',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text("evidencia", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 8), // Espacio de 8 píxeles

            AppTextField(
              controller: _numeroController,
              hintText: 'adjuanta una evidencia ',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 8),

            BotonAdjuntoNuevo(
              titulo: 'Agregar audio',
              subtitulo: '',
              icono: Icons.mic,
              onTap: () {},
            ),
            BotonAdjuntoNuevo(
              titulo: 'Agregar foto',
              subtitulo: '',
              icono: Icons.image,
              onTap: () {},
            ),
            BotonAdjuntoNuevo(
              titulo: 'Agregar video',
              subtitulo: '',
              icono: Icons.videocam,
              onTap: () {},
            ),

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
