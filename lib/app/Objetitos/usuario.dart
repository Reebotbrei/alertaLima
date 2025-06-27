// lib/app/Objetitos/usuario.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String uid; // <-- Propiedad 'uid' declarada
  final String nombre;
  final String email;
  final bool empadronado;
  final int? dni;
  final String? distrito;
  final String? imageUrl;
  final DateTime? fechaNacimiento; // <-- Propiedad 'fechaNacimiento' declarada
  final String? genero; // <-- Propiedad 'genero' declarada
  final String? numeroTelefono; // <-- Propiedad 'numeroTelefono' declarada

  const Usuario({
    required this.uid, // <-- 'uid' requerido en el constructor
    required this.nombre,
    required this.email,
    required this.empadronado,
    this.dni, // Estos son opcionales (nullable)
    this.distrito, // Estos son opcionales (nullable)
    this.imageUrl, // Estos son opcionales (nullable)
    this.fechaNacimiento, // <-- 'fechaNacimiento' en el constructor como opcional
    this.genero, // <-- 'genero' en el constructor como opcional
    this.numeroTelefono, // <-- 'numeroTelefono' en el constructor como opcional
  });

  // Constructor factory para crear una instancia de Usuario desde un DocumentSnapshot de Firestore
  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    // Es crucial manejar el caso en que doc.data() sea null
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      // Si el documento no tiene datos, crea un Usuario básico para evitar errores.
      // Usa doc.id para el UID, ya que es el identificador del documento.
      return Usuario(
        uid: doc.id,
        nombre: 'Usuario Desconocido',
        email: 'desconocido@example.com',
        empadronado: false,
      );
    }

    // Casteo seguro de los campos. Los nombres de los campos deben coincidir
    DateTime? parsedFechaNacimiento;
    // Manejo para convertir Timestamp o String a DateTime
    if (data['FechaNacimiento'] is Timestamp) {
      parsedFechaNacimiento = (data['FechaNacimiento'] as Timestamp).toDate();
    } else if (data['FechaNacimiento'] is String) {
      parsedFechaNacimiento = DateTime.tryParse(data['FechaNacimiento']);
    }

    return Usuario(
      uid: doc.id, // El UID se obtiene del ID del documento de Firestore
      nombre: data['Nombre'] as String? ?? 'Desconocido',
      email: data['Email'] as String? ?? 'sin_email@ejemplo.com',
      empadronado: data['Empadronado'] as bool? ?? false,
      dni: data['DNI'] as int?,
      distrito: data['Distrito'] as String?,
      imageUrl: data['ImageUrl'] as String?,
      fechaNacimiento: parsedFechaNacimiento,
      genero: data['Genero'] as String?,
      numeroTelefono: data['NumeroTelefono'] as String?,
    );
  }

  // Método para convertir la instancia de Usuario a un mapa para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'Nombre': nombre,
      'Email': email,
      'Empadronado': empadronado,
      'DNI': dni,
      'Distrito': distrito,
      'ImageUrl': imageUrl,
      'FechaNacimiento': fechaNacimiento != null ? Timestamp.fromDate(fechaNacimiento!) : null,
      'Genero': genero,
      'NumeroTelefono': numeroTelefono,
    };
  }

  // Método copyWith para crear una nueva instancia de Usuario con algunos campos modificados
  Usuario copyWith({
    String? uid,
    String? nombre,
    String? email,
    bool? empadronado,
    int? dni,
    String? distrito,
    String? imageUrl,
    DateTime? fechaNacimiento,
    String? genero,
    String? numeroTelefono,
  }) {
    return Usuario(
      uid: uid ?? this.uid,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      empadronado: empadronado ?? this.empadronado,
      dni: dni ?? this.dni,
      distrito: distrito ?? this.distrito,
      imageUrl: imageUrl ?? this.imageUrl,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      genero: genero ?? this.genero,
      numeroTelefono: numeroTelefono ?? this.numeroTelefono,
    );
  }
}