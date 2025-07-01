import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MiWidgetVideo extends StatefulWidget {
  @override
  _MiWidgetVideoState createState() => _MiWidgetVideoState();
}

class _MiWidgetVideoState extends State<MiWidgetVideo> {
  final ImagePicker _picker = ImagePicker(); // ✅ Instancia necesaria
  File? _video; // ✅ Variable para almacenar el video

  void _seleccionarVideo() async {
    final vid = await _picker.pickVideo(source: ImageSource.camera);
    if (vid != null) {
      setState(() {
        _video = File(vid.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _seleccionarVideo,
          child: Text('Grabar Video'),
        ),
        if (_video != null)
          Text('Video seleccionado: ${_video!.path.split('/').last}'),
      ],
    );
  }
}
