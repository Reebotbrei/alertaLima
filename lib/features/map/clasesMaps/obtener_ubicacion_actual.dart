import 'package:geolocator/geolocator.dart';

class UbicacionHelper {
  static Future<String> obtenerUbicacion() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) return 'GPS desactivado';

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) return 'Permiso denegado';
    }

    if (permiso == LocationPermission.deniedForever) {
      return 'Permiso denegado permanentemente';
    }

    Position posicion = await Geolocator.getCurrentPosition();
    return '${posicion.latitude}, ${posicion.longitude}';
  }
}
