import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  @override 
  State<MapView> createState() => MapState();
}

class MapState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _defaultStart = CameraPosition(
    target: LatLng(33.672184, -117.714945),
    bearing: 0, 
    tilt: 0,
    zoom: 10,
  );

  @override 
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal, 
        initialCameraPosition: _defaultStart,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      )
    );
  }
}