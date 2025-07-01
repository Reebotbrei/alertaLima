import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MiWidgetConCamara extends StatefulWidget {
  @override
  _MiWidgetConCamaraState createState() => _MiWidgetConCamaraState();
}

class _MiWidgetConCamaraState extends State<MiWidgetConCamara> {
  final ImagePicker _picker = ImagePicker(); // ✅ Necesario
  File? _image; // ✅ Imagen seleccionada

  void _seleccionarImagen() async {
    final img = await _picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        _image = File(img.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _seleccionarImagen,
          child: Text('Tomar Foto'),
        ),
        if (_image != null) Image.file(_image!),
      ],
    );
  }
}
