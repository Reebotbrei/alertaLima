import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:alerta_lima/features/map/clasesMaps/estilo_Mapa.dart';
import 'package:alerta_lima/app/widgets/app_alert_card.dart';
import 'package:flutter/material.dart';
import 'package:alerta_lima/features/map/clasesMaps/marcador_Zonas.dart';

class HomeController {
  //controlador de mapa
  GoogleMapController? _mapController;
  Set<Marker> marcadores = {};
  final Set<Circle> zonasDeAlerta = {}; // Círculos en el mapa
  //lista para una prueva rapida de la zonas de robo esta se tendra que sa cara de las denucncias
  //y los reportes
  final List<LatLng> coordenadasZonasConcurridasRobo = [
    LatLng(-11.957840, -76.999800),
    LatLng(-11.950890, -76.982320),
    LatLng(-11.955370, -76.997510),
    LatLng(-11.957500, -76.984300),
    LatLng(-11.967350, -76.986990),
    LatLng(-11.942400, -76.976400),
    LatLng(-11.964750, -76.979990),
  ];

  void generarZonasDeConcurrencia() {
    final marcadorZonas = MarcadorZonas(coordenadasZonasConcurridasRobo);
    zonasDeAlerta.clear();
    zonasDeAlerta.addAll(marcadorZonas.generarCirculos());
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller; // Se guarda el controlador para usarlo después
    controller.setMapStyle(
      mapStyle,
    ); // Se aplica el estilo personalizado al mapa en este caso tipo uber (oño)
  }

  //matodo para  mover la camra del mapa ala ubicacion actal del ususario
  Future<void> moverACamaraUsuario(BuildContext context) async {
    //verificamos si el gps esta activado
    bool gpsActivo = await Geolocator.isLocationServiceEnabled();
    if (!gpsActivo) {
      //llmamos a nuesta ventana de alerta emergente si gps esta desactivado
      //prviene de app_alert_card
      AppAlertCard.show(
        context: context,
        title: 'Ubicación requerida',
        message: 'Para continuar, debes activar el GPS del dispositivo.',
        primaryButtonText: 'Activar',
        onPrimaryPressed: () {
          // Acción: abrir ajustes de ubicación
          Geolocator.openLocationSettings();
        },
        secondaryButtonText: 'Cancelar',
        onSecondaryPressed: () {
          // Acción secundaria si es necesario
        },
      );
      return;
    }
    // Verifica si la app tiene permisos de ubicación
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      // Si el permiso está denegado, lo solicita
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return;
      }
    }
    // Si el permiso fue denegado permanentemente, ya no se puede pedir
    if (permiso == LocationPermission.deniedForever) {
      return;
    }
    // Si todo está en orden, obtiene la ubicación actual
    Position posicion = await Geolocator.getCurrentPosition();
    // Se transforma en coordenadas para el mapa
    LatLng ubicacion = LatLng(posicion.latitude, posicion.longitude);
    // Agregar marcador azul en la ubicación actual
    final marcador = Marker(
      markerId: MarkerId('usuario'),
      position: ubicacion,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ), // Cambiar color aquí
      infoWindow: InfoWindow(title: 'Tu ubicación'),
    );

    marcadores.clear(); // Opcional: limpiar anteriores
    marcadores.add(marcador);

    // Si el controlador del mapa está disponible, mueve la cámara hacia la ubicación del usuario
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: ubicacion,
            zoom: 17,
          ), //se envia como argumento ubicaion y zoom de acercamitnoa
        ),
      );
    }
  }
}
