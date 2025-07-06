import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String uid; //

  final String nombre;
  final bool? empadronado;
  final String email;
  final int? dni;
  final String? distrito;
  final String? contrasena;
  final DateTime? fechaNacimiento;
  final String? numeroTelefono;
  final String? genero;

  final String? imageUrl;
  final String? provincia;
  final String? urbanizacion;
  final String? direccionDetallada;

  const Usuario({
    required this.uid,

    required this.nombre,
    required this.email,
    this.numeroTelefono,
    this.fechaNacimiento,
    this.empadronado,
    this.dni,
    this.contrasena,
    this.distrito,
    this.genero,

    this.imageUrl,
    this.provincia,
    this.urbanizacion,
    this.direccionDetallada,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final inforDeFireStore = doc.data() as Map<String, dynamic>;

    return Usuario(
      uid: doc.id,

      nombre: inforDeFireStore['Nombre'] ?? 'N/A',
      distrito: inforDeFireStore['Distrito'],
      email: inforDeFireStore['Email'] ?? 'N/A',
      empadronado: inforDeFireStore['Empadronado'],
      dni: inforDeFireStore["DNI"],

      fechaNacimiento: (inforDeFireStore["FechaNacimiento"] as Timestamp?)
          ?.toDate(),
      genero: inforDeFireStore["Genero"],
      //
      numeroTelefono: inforDeFireStore["NumeroTelefono"],
      imageUrl: inforDeFireStore["ImageUrl"],
      provincia: inforDeFireStore["Provincia"],
      urbanizacion: inforDeFireStore["Urbanizacion"],
      direccionDetallada: inforDeFireStore["DireccionDetallada"],
      //
    );
  }

  //
  Map<String, dynamic> toFirestore() {
    return {
      'Nombre': nombre,
      'Email': empadronado,
      'DNI': dni,
      'Distrito': distrito,
      'FechaNacimiento': fechaNacimiento != null
          ? Timestamp.fromDate(fechaNacimiento!)
          : null,
      'NumeroTelefono': numeroTelefono,
      'Genero': genero,
      'ImageUrl': imageUrl,
      'Provincia': provincia,
      'Urbanizacion': urbanizacion,
      'DireccionDetallada': direccionDetallada,
    };
  }

  Usuario copyWith({
    String? uid,
    String? nombre,
    String? email,
    bool? empadronado,
    int? dni,
    String? distrito,
    String? contrasena,
    DateTime? fechaNacimiento,
    String? numeroTelefono,
    String? genero,
    String? imageUrl,
    String? provincia,
    String? urbanizacion,
    String? direccionDetallada,
  }) {
    return Usuario(
      uid: uid ?? this.uid,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      empadronado: empadronado ?? this.empadronado,
      dni: dni ?? this.dni,
      distrito: distrito ?? this.distrito,
      contrasena: contrasena ?? this.contrasena,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      numeroTelefono: numeroTelefono ?? this.numeroTelefono,
      genero: genero ?? this.genero,
      imageUrl: imageUrl ?? this.imageUrl,
      provincia: provincia ?? this.provincia,
      urbanizacion: urbanizacion ?? this.urbanizacion,
      direccionDetallada: direccionDetallada ?? this.direccionDetallada,
    );
  }
}
