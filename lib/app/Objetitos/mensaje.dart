import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum FromWho { mine, other }

class Mensaje {
  final String mensaje;
  final String? imagen;
  final FromWho fromWho;

  Mensaje({ 
    required this.mensaje, 
    this.imagen, 
    required this.fromWho
  });
}
