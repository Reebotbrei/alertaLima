import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore baseDatos = FirebaseFirestore.instance;

Future<List> getUsuarios() async {
  List usuarios = [];

  CollectionReference coleccionUsarios = baseDatos.collection("Usuario");
  QuerySnapshot queryUsuario = await coleccionUsarios.get();
  return usuarios;
}