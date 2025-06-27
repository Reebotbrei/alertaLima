// lib/models/user_model.dart
import 'dart:io';

class User {
  String id; // Considera añadir un ID único para cada usuario (ej. Firebase UID)
  String name;
  String email;
  String phone;
  String dni;
  File? imageFile;       // Para la imagen seleccionada localmente
  String? imageUrl;      // Para la URL de la imagen si se carga de un servidor/Firebase
  DateTime? dateOfBirth; // Nuevo campo para la fecha de nacimiento
  String? gender;        // Nuevo campo para el género

  User({
    required this.id, // Ahora se requiere un ID
    required this.name,
    required this.email,
    required this.phone,
    required this.dni,
    this.imageFile,
    this.imageUrl,
    this.dateOfBirth,
    this.gender,
  });

  bool get estaEmpadronado => dni.isNotEmpty && phone.isNotEmpty;

  // Opcional: Métodos para serializar/deserializar (útil para Firebase/APIs)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      dni: json['dni'] as String,
      imageUrl: json['imageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'] as String?,
      // imageFile no se deserializa directamente de JSON, se maneja aparte
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dni': dni,
      'imageUrl': imageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
    };
  }
}