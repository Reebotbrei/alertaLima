import 'package:cloud_firestore/cloud_firestore.dart';

class ChatViewmodel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getAutorithies() {
    return _firestore.collection("Usuario").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }
}
