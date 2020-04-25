import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  Map locationsToDisplay = Map();
  MapView({this.locationsToDisplay});
  
  @override 
  State<MapView> createState() => MapState(locationsToDisplay: locationsToDisplay);
}

class MapState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  Map locationsToDisplay = Map();

  MapState({this.locationsToDisplay});

  static final CameraPosition _defaultStart = CameraPosition(
    target: LatLng(33.693139, -117.789026),
    bearing: 0, 
    tilt: 0,
    zoom: 12,
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