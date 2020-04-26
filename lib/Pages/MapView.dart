import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:recharge/Assets/locations.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class MapView extends StatefulWidget {
  FirebaseApp app;

  MapView({this.app});
  @override
  _MapViewState createState() => _MapViewState(
    app: app,
  );
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  FirebaseApp app; 
  Map locationsData = Map();
  bool wait_before_return = true;
  bool markers_ready = false;

  BitmapDescriptor foodIcon;
  BitmapDescriptor drinksIcon;
  BitmapDescriptor groceryIcon;

  Set<Marker> _markers = Set<Marker>();
  
  _MapViewState({this.app});

  Future<void> master_markers_setup() async {
    await retrieveLocationData();
    await loadMarkerIcons();
    Set<Marker> markersToSubmit = _setupMarkers();
    setState(() {
      _markers = markersToSubmit;
    });
  }

  Future<void> loadMarkerIcons() async {
    var foodValue = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'image_assets/pin_food.png');
    foodIcon = foodValue;
    var drinksValue = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'image_assets/pin_drinks.png');
    drinksIcon = drinksValue;
    var groceryValue = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'image_assets/pin_grocery.png');
    groceryIcon = groceryValue;
  }

  void initState() {
    master_markers_setup();
  }

  Future<void> retrieveLocationData() async {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    DataSnapshot snapshot = await database.reference().child('locations').once();
    print('Connected to database and fetched ${snapshot.value}');
    List locationsDescriptions = List();
    Map locations = Map();
    locationsDescriptions = snapshot.value;
    print("printing locationsDescriptions");
    print(locationsDescriptions);
    assert(locationsDescriptions is List);
    for (int i=0;i<locationsDescriptions.length;i++) {
      Map row = locationsDescriptions[i];
      if (locations.containsKey(row['category'])) {
        locations[row['category']].add([row['latitude'], row['longitude']]);
      } else {
        locations[row['category']] = [[row['latitude'], row['longitude']]];
      }
    }
    print("Printing locations map.");
    print(locations);
    locationsTruth = locations;
    locationsData = locations;
    print('FINISHED RETRIEVING LOCATION DATA FROM DATABASE');
  }

  static final CameraPosition _defaultStart = CameraPosition(
    target: LatLng(33.693139, -117.789026),
    bearing: 0, 
    tilt: 0,
    zoom: 12,
  );

  Set<Marker> _setupMarkers() {
    // grabs the global locationsTruth to generate
    Set<Marker> markersToReturn = Set<Marker>();
    print('_setupMarkers is running.');
    print('locationsData.');
    print(locationsData);
    // assuming global locationsTruth is set. 
    locationsData.forEach((category, coords) {
      print('printing [category, coords]');
      print([category, coords]);
      print('printing coords.length.');
      print(coords.length);
      for (int i=0;i<coords.length;i++) {
        if (category == 'Food') {
          markersToReturn.add(
            Marker(
              markerId: MarkerId(category + '$i'),
              position: LatLng(coords[i][0], coords[i][1]),
              icon: foodIcon,
            )
          );
        } else if (category == "Drinks") {
          markersToReturn.add(
            Marker(
              markerId: MarkerId(category + '$i'),
              position: LatLng(coords[i][0], coords[i][1]),
              icon: drinksIcon,
            )
          );
        } else if (category == "Grocery") {
          markersToReturn.add(
            Marker(
              markerId: MarkerId(category + '$i'),
              position: LatLng(coords[i][0], coords[i][1]),
              icon: groceryIcon,
            )
          );
        }
      }
    });
    return markersToReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        initialCameraPosition: _defaultStart,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          print('ADDING ONE MARKER');
          setState(() {

          });
        }
      )
    );
  }
}