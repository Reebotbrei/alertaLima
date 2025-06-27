import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Timestamp

class Usuario {
  final String uid; // Usa 'uid' como identificador, consistente con Firebase Auth
  final String nombre;
  final String email;
  final bool empadronado;
  final int? dni; // Puede ser nulo
  final String? distrito; // Puede ser nulo
  final String? imageUrl; // Puede ser nulo
  final DateTime? fechaNacimiento; // Nuevo campo
  final String? genero; // Nuevo campo
  final String? numeroTelefono; // Nuevo campo, mapea a 'phone' si es el mismo

  const Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.empadronado,
    this.dni,
    this.distrito,
    this.imageUrl,
    this.fechaNacimiento,
    this.genero,
    this.numeroTelefono,
  });

  // Constructor factory para crear Usuario desde un DocumentSnapshot de Firestore
  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Cast a Map<String, dynamic> y hazlo nullable

    if (data == null) {
      // Manejar el caso donde el documento no tiene datos
      throw StateError('Documento de Firestore sin datos para UID: ${doc.id}');
    }

    // Convertir Timestamp a DateTime si el campo existe
    DateTime? parsedFechaNacimiento;
    if (data['FechaNacimiento'] is Timestamp) {
      parsedFechaNacimiento = (data['FechaNacimiento'] as Timestamp).toDate();
    } else if (data['FechaNacimiento'] is String) {
      // Si guardas como String (aunque Timestamp es preferido para fechas)
      parsedFechaNacimiento = DateTime.tryParse(data['FechaNacimiento']);
    }

    return Usuario(
      uid: doc.id, // El UID es el ID del documento
      nombre: data['Nombre'] as String? ?? 'Desconocido', // Usa '?' para acceso seguro y ?? para valor por defecto
      email: data['Email'] as String? ?? 'sin_email@ejemplo.com',
      empadronado: data['Empadronado'] as bool? ?? false,
      dni: data['DNI'] as int?, // null si no existe o no es int
      distrito: data['Distrito'] as String?,
      imageUrl: data['ImageUrl'] as String?,
      fechaNacimiento: parsedFechaNacimiento,
      genero: data['Genero'] as String?,
      numeroTelefono: data['NumeroTelefono'] as String?, // Asegúrate de que el campo en Firestore sea 'NumeroTelefono'
    );
  }

  // Método para convertir Usuario a Map para Firestore
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

  // Método copyWith para crear una nueva instancia con propiedades modificadas
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