import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarcadorZonas {
  final List<LatLng> coordenadas;

  MarcadorZonas(this.coordenadas);

  Set<Circle> generarCirculos() {
    final Set<Circle> circulos = {};
    for (int i = 0; i < coordenadas.length; i++) {
      circulos.add(
        Circle(
          circleId: CircleId('zona_$i'),
          center: coordenadas[i],
          radius: 150,
          fillColor: const Color.fromARGB(100, 255, 0, 0),
          strokeColor: Colors.red,
          strokeWidth: 1,
        ),
      );
    }
    return circulos;
  }
}
