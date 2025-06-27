import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//clase para representar zonas de riesgo
class MarcadorZonas {
  //lista de coordenadas donde se colocara los circulos
  //latitud y logitud
  final List<LatLng> coordenadas;
  //constructor recive una lista de coordenadas
  MarcadorZonas(this.coordenadas);
  //metodo qu genera  un conjunto de cirulos apartir de las coordenadas
  Set<Circle> generarCirculos() {
    final Set<Circle> circulos =
        {}; //conjunto para almacenar los circulos generados
    //itera sobre todas las coordenada para crear un circulo
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
