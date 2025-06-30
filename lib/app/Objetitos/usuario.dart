import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String nombre;
  bool? empadronado;
  String email;
  int? dni;
  String? distrito;
  DateTime? fechaNacimiento;
  int? numeroTelefono;
  String? genero;
  String id;
  String? vecindario;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    this.numeroTelefono,
    this.fechaNacimiento,
    this.empadronado,
    this.dni,
    this.distrito,
    this.genero,
    this.vecindario,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc, id) {
    final inforDeFireStore = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: id,
      dni: inforDeFireStore["DNI"],
      distrito: inforDeFireStore['Distrito'],
      email: inforDeFireStore['Email'],
      empadronado: inforDeFireStore['Empadronado'],
      fechaNacimiento: inforDeFireStore["FechaNacimiento"],
      genero: inforDeFireStore["Genero"],
      nombre: inforDeFireStore['Nombre'],
      numeroTelefono: inforDeFireStore['NumeroTelefono'],
      vecindario: inforDeFireStore['Vecindario']
    );
  }
}
