import 'package:cloud_firestore/cloud_firestore.dart';


class Mensaje {
  String autorID;
  String autorNombre;
  String texto;
  Timestamp timestamp;
  Mensaje({
    required this.autorID,
    required this.autorNombre, 
    required this.texto,
    required this.timestamp  
  });
  
  Map<String, dynamic> toMap() {
    return {
      'autorID': autorID,
      'autorNombre': autorNombre,
      'message': texto,
      'timeStamp': timestamp,
    };
  }
}
