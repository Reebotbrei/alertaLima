import 'package:alerta_lima/app/Objetitos/usuario.dart';
import 'package:alerta_lima/features/chat/chat_vecinal/view/presentacion/chat/Mensaje.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatVecinalServices {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessages(Usuario user, message) async {

    final Timestamp timestamp = Timestamp.now();

    Mensaje newMessage = Mensaje(
      autorID: user.id,
      autorNombre: user.nombre,
      texto: message,
      timestamp: timestamp,
    );

    await _firestore
        .collection("Distritos")
        .doc(user.distrito)
        .collection("Vecindarios")
        .doc(user.vecindario)
        .collection("Messages")
        .add(newMessage.toMap());
  }
}
