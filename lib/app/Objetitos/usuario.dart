import 'package:cloud_firestore/cloud_firestore.dart';
class Usuario {
  final String nombre;
  final bool? empadronado;
  final String email;
  final int? dni;
  final String? distrito;
  final String? contrasena;

  const Usuario({
    required this.nombre,
    this.empadronado,
    required this.email,
    this.dni,
    this.contrasena,
    this.distrito,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc){
    final inforDeFireStore = doc.data() as  Map<String, dynamic>;
    return Usuario(
      nombre: inforDeFireStore['Nombre'],
      distrito: inforDeFireStore['Distrito'],
      email: inforDeFireStore['Email'],
      empadronado: inforDeFireStore['Empadronado'],
      dni: inforDeFireStore["DNI"]
    );
  }









}
