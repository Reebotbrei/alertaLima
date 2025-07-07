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

  String? provincia;
  String? urbanizacion;
  String? direccionDetallada;
  String? imageUrl;

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

    this.provincia,
    this.urbanizacion,
    this.direccionDetallada,
    this.imageUrl,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc, id) {
    final inforDeFireStore = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: id, //doc.id para obtener los datos del usuario ingresado y poder modificarlos
      dni: inforDeFireStore["DNI"],
      distrito: inforDeFireStore['Distrito'],
      email: inforDeFireStore['Email'],
      empadronado: inforDeFireStore['Empadronado'],
      fechaNacimiento: (inforDeFireStore["FechaNacimiento"] as Timestamp?)
          ?.toDate(),
      genero: inforDeFireStore["Genero"],
      nombre: inforDeFireStore['Nombre'],
      numeroTelefono: inforDeFireStore['NumeroTelefono'],
      vecindario: inforDeFireStore['Vecindario'],

      provincia: inforDeFireStore['Provincia'],
      urbanizacion: inforDeFireStore['Urbanizacion'],
      direccionDetallada: inforDeFireStore['DireccionDetallada'],
      imageUrl: inforDeFireStore['imageUrl'],
    );
  }

  //CAMBIOS

  /*Metodo map para convertir el objeto usuario a un map para que firestore se
pueda comunicar con Firebase y se puedan realizar los cambios y modificaciones
del usuario*/

  Map<String, dynamic> toFirestore() {
    return {
      "DNI": dni,
      "Distrito": distrito,
      "Email": email,
      "Empadronado": empadronado,
      "FechaNacimiento": fechaNacimiento != null
          ? Timestamp.fromDate(fechaNacimiento!)
          : null,
      "Genero": genero,
      "Nombre": nombre,
      "NumeroTelefono": numeroTelefono,
      "Vecindario": vecindario,
      "Provincia": provincia,
      "Urbanizacion": urbanizacion,
      "DireccionDetallada": direccionDetallada,
      "imageUrl": imageUrl,
    };
  }

  //Metodo copyWith para facilitar la modificación del usuario

  Usuario copyWith({
    String? id,
    String? nombre,
    bool? empadronado,
    String? email,
    int? dni,
    String? distrito,
    DateTime? fechaNacimiento,
    int? numeroTelefono,
    String? genero,
    String? vecindario,
    String? provincia,
    String? urbanizacion,
    String? direccionDetallada,
    String? imageUrl,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      empadronado: empadronado ?? this.empadronado,
      email: email ?? this.email,
      dni: dni ?? this.dni,
      distrito: distrito ?? this.distrito,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      numeroTelefono: numeroTelefono ?? numeroTelefono,
      genero: genero ?? this.genero,
      vecindario: vecindario ?? this.vecindario,
      provincia: provincia ?? this.provincia,
      urbanizacion: urbanizacion ?? this.urbanizacion,
      direccionDetallada: direccionDetallada ?? this.direccionDetallada,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
