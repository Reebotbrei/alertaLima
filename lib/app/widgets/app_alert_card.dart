//wiget para ventana emergente se puede modificar el mensaje elnombre de los botones y funcionalidad de estos
import 'package:flutter/material.dart';

//clase para mostar el cuadro de alerta es de tipo estatico
class AppAlertCard {
  static void show({
    required BuildContext context, //contxto
    required String title, //titulo de aleta
    required String message, //mensaje
    required String primaryButtonText, //primer boton
    required VoidCallback
    onPrimaryPressed, //funcione al precionar el primer boton
    String? secondaryButtonText, //segundo boton opcional
    VoidCallback? onSecondaryPressed, //funciones del segundo boton opcional
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),

        content: Text(message, style: Theme.of(context).textTheme.bodyMedium),

        actions: [
          // Si se proporciona texto y función para el botón secundario, se muestra
          if (secondaryButtonText != null && onSecondaryPressed != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //cierra el cuado
                onSecondaryPressed(); //ejecuta la fuciion
              },
              child: Text(
                secondaryButtonText,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ), // Muestra el texto del botón secundario
            ),
          //boton principal
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPrimaryPressed();
            },
            child: Text(
              primaryButtonText,
            ), // Muestra el texto del botón principal
          ),
        ],
      ),
    );
  }
}

/*     
(SE USA DE ESTA MANERA) 
   ESOS IMPROT TIENES QUE ESTAR SI O SI
import 'package:alerta_lima/app/widgets/app_alert_card.dart';
import 'package:flutter/material.dart';

        AppAlertCard.show(
        context: context,
        title: 'Ubicación requerida',
        message: 'Para continuar, debes activar el GPS del dispositivo.',
        primaryButtonText: 'Activar',
        onPrimaryPressed: () {
          // Acción: abrir ajustes de ubicación
          Geolocator.openLocationSettings();
        },
        secondaryButtonText: 'Cancelar',
        onSecondaryPressed: () {
          // Acción secundaria si es necesario
          print('Usuario canceló');
        },
      );
      
 */
