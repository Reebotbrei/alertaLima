import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String nombre;
  final bool? empadronado;
  final String email;
  final int? dni;
  final String? distrito;
  final String? contrasena;
  final DateTime? fechaNacimiento;
  final int? numeroTelefono;
  final String? genero;

  const Usuario({
    required this.nombre,
    required this.email,
    this.numeroTelefono,
    this.fechaNacimiento,
    this.empadronado,
    this.dni,
    this.contrasena,
    this.distrito,
    this.genero
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final inforDeFireStore = doc.data() as Map<String, dynamic>;
    
    return Usuario(
      nombre: inforDeFireStore['Nombre'],
      distrito: inforDeFireStore['Distrito'],
      email: inforDeFireStore['Email'],
      empadronado: inforDeFireStore['Empadronado'],
      dni: inforDeFireStore["DNI"],
      fechaNacimiento: inforDeFireStore["FechaNacimiento"],
      genero : inforDeFireStore["Genero"],
    );
  }
}
