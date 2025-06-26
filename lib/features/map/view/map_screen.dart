//usamos un statefulwidget
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app/theme/app_colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  //variable para guardar el dato de tipo camera position es de tipo final y privado
  //a camara position le pasamos una instancia de la clase latdna qu trabaja con latitud y longitud
  final _initialCameraPosition = CameraPosition(
    target: LatLng(-11.980688, -76.9884012),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //llamamos al appbar
      appBar: AppBar(title: const Text('Inicio'), centerTitle: true),
      //la body le pasamos un witget de tipo googlemap con los parametros de latitud y longitud
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
