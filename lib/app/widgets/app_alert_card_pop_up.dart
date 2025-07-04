import 'package:flutter/material.dart';

void mostrarOpcionesBottomSheet({
  required BuildContext context,
  required List<Map<String, dynamic>> opciones,
}) {
  // Muestra el modal en la parte inferior de la pantalla
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(
      context,
    ).scaffoldBackgroundColor, // usa el color del tema
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      // Aplica esquinas redondeadas en la parte superior
    ),

    // Define el contenido del modal
    builder: (_) => Column(
      mainAxisSize:
          MainAxisSize.min, // Ocupa solo el espacio necesario para las opciones
      children: opciones.map((opcion) {
        // Crea una lista de elementos visuales a partir de la lista de mapas
        return ListTile(
          leading: Icon(
            opcion['icono'], // Ícono de la opción
            color: Theme.of(
              context,
            ).iconTheme.color, // Color del ícono según el tema
          ),
          title: Text(
            opcion['titulo'],
            style: Theme.of(
              context,
            ).textTheme.bodyMedium, // Estilo del texto según el tema
          ),
          onTap: () async {
            Navigator.pop(context); // Cierra el modal
            await opcion['accion'](); // Ejecuta la acción asociada a esa opción
          },
        );
      }).toList(), // Convierte la lista de opciones en widgets ListTile
    ),
  );
}


/*  SE INVOCA DE ESTA MANERA 
 mostrarOpcionesBottomSheet(
          context: context,
          opciones: [
            {
              'titulo': '',
              'icono': Icons.mic,
              'accion': () async {ACCIONES A EJECUETAR},
            },
            {
              'titulo': 'Seleccionar desde archivos',
              'icono': Icons.library_music,
              'accion': () async {ACCIONES A EJECUTAR},
            },
          ],
        );


 */