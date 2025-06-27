//usamos un statefulwidget
import 'package:alerta_lima/features/map/clasesMaps/home_controler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class pantallaMapa extends StatefulWidget {
  const pantallaMapa({super.key});

  @override
  State<pantallaMapa> createState() => pantallaMapaState();
}

class pantallaMapaState extends State<pantallaMapa> {
  //definimos el controller
  final _controller = HomeController();
  //variable para guardar el dato de tipo camera position es de tipo final y privado
  //a camara position le pasamos una instancia de la clase latdna qu trabaja con latitud y longitud
  final _initialCameraPosition = CameraPosition(
    target: LatLng(-11.9699681, -77.0065869),
    zoom: 15,
  );

  //generamos los circulos rojo de mayor conucerria
  @override
  void initState() {
    super.initState();
    _controller.generarZonasDeConcurrencia(); //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //llamamos al appbar
      appBar: AppBar(title: const Text('Mapa De Seguridad'), centerTitle: true),
      //la body le pasamos un witget de tipo googlemap con los parametros de latitud y longitud
      body: Stack(
        children: [
          // El mapa
          GoogleMap(
            onMapCreated: _controller.onMapCreated,
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false, //eliminamos los botones de zoom
            markers: _controller
                .marcadores, //para cambiar el color de los marcadores
            circles: _controller.zonasDeAlerta, // 👈 muestra los círculos
          ),

          // El botón flotante para moverse a la ubicación actual
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 255, 254, 255),
              shape: const CircleBorder(),
              onPressed: () async {
                await _controller.moverACamaraUsuario(
                  context,
                ); // Espera a que se obtenga la ubicación y se agregue el marcador
                setState(() {}); // Luego actualiza la UI
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
