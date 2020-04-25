import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:recharge/Assets/locations.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  Map locationsToDisplay = Map();

  MapView({this.locationsToDisplay});
  @override
  _MapViewState createState() => _MapViewState(
    locationsToDisplay: locationsToDisplay,
  );
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  Map locationsToDisplay = Map();
  
  _MapViewState({this.locationsToDisplay});

  static final CameraPosition _defaultStart = CameraPosition(
    target: LatLng(33.693139, -117.789026),
    bearing: 0, 
    tilt: 0,
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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