import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../../app/Objetitos/usuario.dart';

/*Model para el manejo de datos de perfil de usuario
se encarga de la comunicación con Firebase Firestore para obtener y guardar
información relacionada al usuario, distritos y vecindarios.*/
class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*Obtiene los datos del usuario desde Firestore por su [uid].
  retorna un objeto [Usuario] si existe, o null si no existe.*/
  Future<Usuario?> getUsuario(String uid) async {
    try {
      final doc = await _firestore.collection('Usuario').doc(uid).get();
      if (doc.exists) {
        return Usuario.fromFirestore(doc, uid);
      }
      return null;
    } catch (e) {
      throw Exception('No se pudo obtener el usuario: $e');
    }
  }

  /// Guarda o actualiza los datos del usuario en Firestore.
  /// Usa el método toFirestore del modelo Usuario.
  Future<void> saveUsuario(Usuario usuario) async {
    try {
      await _firestore
          .collection('Usuario')
          .doc(usuario.id)
          .set(usuario.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('No se pudo guardar el usuario: $e');
    }
  }

  /* Obtiene la lista de distritos desde la colección 'Distritos'
  retorna una lista de nombres de distritos.*/
  Future<List<String>> getDistritos() async {
    try {
      final snapshot = await _firestore.collection('Distritos').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw Exception('No se pudo obtener la lista de distritos: $e');
    }
  }

  /* Obtiene la lista de vecindarios para un distrito específico.
  retorna una lista de nombres de vecindarios.*/
  Future<List<String>> getVecindarios(String distrito) async {
    try {
      final snapshot = await _firestore
          .collection('Distritos')
          .doc(distrito)
          .collection('Vecindarios')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw Exception('No se pudo obtener la lista de vecindarios: $e');
    }
  }

  /// Sube una imagen a Firebase Storage y retorna la URL pública
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      await storageRef.putFile(imageFile);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('No se pudo subir la imagen: $e');
    }
  }
}
