import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:recharge/Assets/fonts.dart';
import 'package:recharge/Assets/data_global.dart';
import 'package:recharge/Assets/shadows.dart';
import 'package:recharge/Assets/my_flutter_app_icons.dart';
import 'package:recharge/Helpers/FadeIn.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recharge/Pages/DetailPage.dart';
import 'package:recharge/Helpers/Zoom.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:recharge/Assets/cloudInfo.dart';



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
  GoogleMapController mapController;
  FirebaseApp app;
  Map locationsData = Map();

  SwiperController _swipeController;

  BitmapDescriptor foodIcon;
  BitmapDescriptor drinksIcon;
  BitmapDescriptor groceryIcon;

  bool movingToPin = false;
  bool displayInfo = false;

  Map currentInfo = Map();

  Set<Marker> _markers = Set<Marker>();

  List allFood;
  List allDrinks;
  List allGroceries;
  List<List> masterList;
  List currentList;
  List<int> numberOfStores;
  Set<Marker> allMarkers;
  Set<Marker> allFoodMarkers;
  Set<Marker> allDrinksMarkers;
  Set<Marker> allGroceryMarkers;
  Set<Marker> currentMarkers;
  List<Color> colors = [green, mainColor, blue, orange];
  List<String> categories = ["All", "Food", "Drinks", "Grocery"];

  static final CameraPosition _defaultStart = CameraPosition(
    target: LatLng(33.693139, -117.789026),
    bearing: 0,
    tilt: 0,
    zoom: 12,
  );

  _MapViewState({this.app});

   _generatLists() {
    allFood = dataTruth.where((i) => i['category'] == "Food").toList();
    allDrinks = dataTruth.where((i) => i['category'] == "Drinks").toList();
    allGroceries = dataTruth.where((i) => i['category'] == "Grocery").toList();
    numberOfStores = [
      dataTruth.length.toInt(),
      allFood.length.toInt(),
      allDrinks.length.toInt(),
      allGroceries.length.toInt()
    ];
    masterList = [dataTruth, allFood, allDrinks, allGroceries];
    print("generated list");
    if (masterList != null) {
      currentList = masterList[0];
    }
  }

  Future<void> master_markers_setup() async {
    await retrieveLocationData();
    await loadMarkerIcons();
    Set<Marker> markersToSubmit = _setupMarkers();
    allMarkers = markersToSubmit;
    currentMarkers = allMarkers;
    print(dataTruth == null); //dataTruth can be accessed
    _generatLists();
    setState(() {
      _markers = markersToSubmit;
    });
  }

  Future<void> loadMarkerIcons() async {
    var foodValue = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'image_assets/pin_food.png');
    foodIcon = foodValue;
    foodIconTruth = foodValue;
    var drinksValue = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'image_assets/pin_drinks.png');
    drinksIcon = drinksValue;
    drinksIconTruth = drinksValue;
    var groceryValue = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'image_assets/pin_grocery.png');
    groceryIcon = groceryValue;
    groceryIconTruth = groceryValue;
  }

  Future<void> retrieveLocationData() async {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    DataSnapshot snapshot =
        await database.reference().child('locations').once();
   // print('Connected to database and fetched ${snapshot.value}');
    List locationsDescriptions = List();
    Map locations = Map();
    locationsDescriptions = snapshot.value;
    dataTruth = snapshot.value;

    Map generatedCoordsToIndex = Map();
    for (int i=0;i<dataTruth.length;i++) {
      var instance = dataTruth[i];
      double lat = instance["latitude"];
      double long = instance["longitude"];
      generatedCoordsToIndex[lat+long] = i;
    }

    coordsToIndex = generatedCoordsToIndex;
   // print('generatedCoordsToIndex finished.');
   // print(generatedCoordsToIndex);

   // print("printing locationsDescriptions");
//print(locationsDescriptions);
    assert(locationsDescriptions is List);
    for (int i = 0; i < locationsDescriptions.length; i++) {
      Map row = locationsDescriptions[i];
      if (locations.containsKey(row['category'])) {
        locations[row['category']].add([row['latitude'], row['longitude']]);
      } else {
        locations[row['category']] = [
          [row['latitude'], row['longitude']]
        ];
      }
    }
   // print("Printing locations map.");
   // print(locations);
    locationsTruth = locations;
    locationsData = locations;
   // print('FINISHED RETRIEVING LOCATION DATA FROM DATABASE');
  }

  Future<String> _coordToAddress(String coordinates) async {
    String request_link = 'https://maps.googleapis.com/maps/api/geocode/json?';
    request_link = request_link + 'latlng=' + coordinates + '&key=' + apiKeyTruth;
    final response = await http.get(request_link);
    if (response.statusCode == 200) {
      var raw_return = jsonDecode(response.body);
   //   print('raw_return');
    //  print(raw_return);
      var formatted_address = raw_return["results"][0]["formatted_address"];
      return formatted_address;
    } else {
      throw Exception('Failed to load distance data.');
    }
  }

  Set<Marker> _setupMarkers() {
    // grabs the global locationsTruth to generate
    Set<Marker> markersToReturn = Set<Marker>();
    allFoodMarkers = Set<Marker> ();
    allDrinksMarkers = Set<Marker> ();
    allGroceryMarkers = Set<Marker> ();
 //   print('_setupMarkers is running.');
 //   print('locationsData.');
  //  print(locationsData);
    // assuming global locationsTruth is set.
    locationsData.forEach((category, coords) {
      //constants
      double markerZoom = 13.5;

      //this number changes offset
      double latOffset = 0.011;

      for (int i = 0; i < coords.length; i++) {
        if (category == 'Food') {
          allFoodMarkers.add(Marker(
            markerId: MarkerId(category + '$i'),
            position: LatLng(coords[i][0], coords[i][1]),
            icon: foodIcon,
            onTap: ()  {
              _prepareInfo(coords[i][0], coords[i][1]);
           //   print('coords[i][0]');
             // print(coords[i][0]);
            //  print('offset applied');
            //  print(coords[i][0] + latOffset);
                _goToPosition(CameraPosition(
                target: LatLng(coords[i][0] + latOffset, coords[i][1]),
                zoom: markerZoom,
              ));
              setState(() {
                movingToPin = true;
              });
            }));
          markersToReturn.add(Marker(
            markerId: MarkerId(category + '$i'),
            position: LatLng(coords[i][0], coords[i][1]),
            icon: foodIcon,
            onTap: ()  {
              _prepareInfo(coords[i][0], coords[i][1]);
           //   print('coords[i][0]');
             // print(coords[i][0]);
            //  print('offset applied');
            //  print(coords[i][0] + latOffset);
                _goToPosition(CameraPosition(
                target: LatLng(coords[i][0] + latOffset, coords[i][1]),
                zoom: markerZoom,
              ));
              setState(() {
                movingToPin = true;
              });
            }));
        } else if (category == "Drinks") {
          allDrinksMarkers.add(Marker(
            markerId: MarkerId(category + '$i'),
            position: LatLng(coords[i][0], coords[i][1]),
            icon: drinksIcon,
            onTap: () {
              _prepareInfo(coords[i][0], coords[i][1]);
              _goToPosition(CameraPosition(
                target: LatLng(coords[i][0] + latOffset, coords[i][1]),
                zoom: markerZoom,
              ));
              setState(() {
                movingToPin = true;
              });
            }));
          markersToReturn.add(Marker(
            markerId: MarkerId(category + '$i'),
            position: LatLng(coords[i][0], coords[i][1]),
            icon: drinksIcon,
            onTap: () {
              _prepareInfo(coords[i][0], coords[i][1]);
              _goToPosition(CameraPosition(
                target: LatLng(coords[i][0] + latOffset, coords[i][1]),
                zoom: markerZoom,
              ));
              setState(() {
                movingToPin = true;
              });
            }));
        } else if (category == "Grocery") {
            allGroceryMarkers.add(Marker(
            markerId: MarkerId(category + '$i'),
            position: LatLng(coords[i][0], coords[i][1]),
            icon: groceryIcon,
            onTap: () {
              _prepareInfo(coords[i][0], coords[i][1]);
              _goToPosition(CameraPosition(
                target: LatLng(coords[i][0] + latOffset, coords[i][1]),
                zoom: markerZoom,
              ));
              setState(() {
                movingToPin = true;
              });
            }));
          markersToReturn.add(Marker(
            markerId: MarkerId(category + '$i'),
            position: LatLng(coords[i][0], coords[i][1]),
            icon: groceryIcon,
            onTap: () {
              _prepareInfo(coords[i][0], coords[i][1]);
              _goToPosition(CameraPosition(
                target: LatLng(coords[i][0] + latOffset, coords[i][1]),
                zoom: markerZoom,
              ));
              setState(() {
                movingToPin = true;
              });
            }));
        }
      }
    });
    print(allGroceryMarkers.length);
    return markersToReturn;
  }

  String _hours(int open, int close) {
    //THIS IS A SHORT CUT, NEED TO REWRITE LATER
    if (open == 0 && close == 0) {
      return 'Open 24 Hours'; 
    } else {
      String openNum = '${(open <= 12) ? open : (open - 12) }';
      String openAP = (open <= 12) ? 'AM' : 'PM';
      String closeNum = '${(close <= 12) ? close : (close - 12) }';
      String closeAP = (close <= 12) ? 'AM' : 'PM';
      return '$openNum $openAP - $closeNum $closeAP';
    }
  }

  void _onTap(int index) {
    _swipeController.move(index, animation: true);
    if (allMarkers != null) {
      switch (index) {
      case 0: currentMarkers = allMarkers; break;
      case 1: currentMarkers = allFoodMarkers; break;
      case 2: currentMarkers = allDrinksMarkers; break;
      case 3: currentMarkers = allGroceryMarkers; break;
    }
    } else {
      print("Hello Bro");
    }
    
    print(currentMarkers.length);
    setState(() {
      displayInfo = false;
      _markers = currentMarkers;
    });



  }

   _goToPosition(CameraPosition newPosition) async {
   // print('animating camera to this position.');
   // print(newPosition.target);
    mapController.animateCamera(CameraUpdate.newCameraPosition(newPosition));

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updateLocation() async {
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    currentLocationTruth = [currentLocation.latitude, currentLocation.longitude];
  //  print('currentLocationTruth');
  //  print(currentLocationTruth);
  }

  void _cameraMoveStarted() {
    _updateLocation();
    if (movingToPin) {
      setState(() {
        displayInfo = true;
        movingToPin = false;
      });
    } else {
      setState(() {
        displayInfo = false;
      });
    }
  }

  void _prepareInfo(double latitude, double longitude) {
    var index = coordsToIndex[latitude+longitude];
  ////  print('sum');
  //  print(latitude+longitude);
//  print('reverse keyed index');
//  print(index);
  //  print('coordsToIndex');
  //  print(coordsToIndex);
    Map data_row = dataTruth[index];
    setState(() {
      currentInfo = data_row;
    });
  }

  void _onMapTap(LatLng tapLocation) {
    setState(() {
      movingToPin = false;
      displayInfo = false;
    });
  }

  @override
  void initState() {
    super.initState();
    master_markers_setup();
    _updateLocation();
    _swipeController = new SwiperController();
   
  }

  Widget build(BuildContext context) {
    _swipeController.index = 0;
    return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onCameraMoveStarted: _cameraMoveStarted,
              mapType: MapType.normal,
              markers: _markers,
              initialCameraPosition: _defaultStart,
              onMapCreated: (GoogleMapController controller) {
                _onMapCreated(controller);
                setState(() {});
              },
              myLocationEnabled: true,
              onTap: _onMapTap,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                  width: currentWidth,
                  height: 193,
                  child: FadeIn(
                      3,
                      new Swiper(
                        scale: 0.4,
                        itemBuilder: (BuildContext context, int index) {

                          return Padding(
                            padding: EdgeInsets.only(
                                left: 2.0, right: 2.0, top: 40, bottom: 40),
                            child: new Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: cardShadow),
                                child: Center(
                                    child: Column(

                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0, right: 10),
                                            child: Icon(MyFlutterApp.circle,
                                                size: 15, color: colors[index]),
                                          ),
                                          AutoSizeText(categories[index],
                                              minFontSize: 12,
                                              maxLines: 1,
                                              style: categoryHeader),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Text(
                                                  numberOfStores[index]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 45,
                                                      fontFamily: (index ==
                                                              _swipeController.index)
                                                          ? 'NunitoBold'
                                                          : 'NunitoRegular'))),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 9.0),
                                            child: Text("loactions \nfound",
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'NunitoLight')),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))),
                          );
                        },
                        controller: _swipeController,
                        loop: false,
                        itemCount: categories.length,
                        viewportFraction: 0.36,
                        onTap: (index) {
                          _onTap(index);
                        },
                      ))),
            ),
        Positioned(
          left: 30,
          bottom: 140,
          child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  boxShadow: buttonShadow),
              child: ClipOval(
                child: Material(
                  elevation: 8.0,
                  color: white,
                  // button color
                  child: InkWell(
                    splashColor: gray, // inkwell color
                    child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          MyFlutterApp.current_location,
                          color: mainColor,
                        )),
                    onTap: () {
                      var current_location = CameraPosition(
                        target: LatLng(currentLocationTruth[0], currentLocationTruth[1]),
                        zoom: 14,
                      );
                      _goToPosition(current_location);
                    },
                  ),
                ),
              )),
        ),
        (displayInfo) ?
        Center(
            child: Container(
                width: 150,
                height: 130,
                decoration: BoxDecoration(
                  color: white,
                  boxShadow: cardShadow,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15.0, right: 10),
                            child: Icon(MyFlutterApp.circle,
                                size: 15, color: mainColor),
                          ),
                          AutoSizeText(currentInfo["name"], // NAME ENTRY HERE
                              minFontSize: 12,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: black,
                                  fontFamily: 'NunitoBold')),
                          Spacer(),
                        ], 
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 40.0),
                      child: Row(
                        children: <Widget>[
                          Text(_hours(currentInfo['open_time'], currentInfo['close_time']), // IMPLEMENT TIMES OPEN
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'NunitoRegular',
                                  color: green)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 20.0),
                      child: Row(
                        children: <Widget>[
                          AutoSizeText(currentInfo["summary"],
                              maxLines: 1,
                              minFontSize: 8,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'NunitoRegular',
                                  color: black)),
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Container(
                  width: 110 * widthRatio,
                  height: 27 * widthRatio,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [mainColor, secondaryColor], begin: Alignment.topRight, end: Alignment.bottomLeft),
                      
                   
                      borderRadius:
                          BorderRadius.all(Radius.circular(13.5 * widthRatio)),
                  ),
                  child: FlatButton(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(35))),
                      onPressed: () async {
                        var printable_coordinates = await _coordToAddress('${currentInfo['latitude']},${currentInfo['longitude']}');
                       // print('printable_coordinates');
                      //  print(printable_coordinates);
                        Navigator.push(context, ScaleRoute(page: DetailPage(
                          name: currentInfo["name"],
                          offerings: currentInfo["offerings"], 
                          openTime: currentInfo["open_time"], 
                          closeTime: currentInfo["close_time"], 
                          address: printable_coordinates, 
                          category: currentInfo["category"], 
                          coords: LatLng(currentInfo['latitude'] + centerMarkerOffset, currentInfo['longitude']),
                          markerCoords: LatLng(currentInfo['latitude'], currentInfo['longitude']),
                        )));
                        
                      },
                      child: Center(
                        child: Text(
                          'Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'NunitoBold',
                              color: white),
                        ),
                      ),
                  ),
                ),
                    ),
                  ],
                ))) : Container()
      ],
    ));
  }
}
