enum FromWho { mine, other }

class Mensaje {
  final String mensaje;
  final String? imagen;
  final FromWho fromWho;
  final String? nombre;

  Mensaje({
    required this.mensaje,
    this.imagen, 
    required this.fromWho,
    required this.nombre
  });
}
