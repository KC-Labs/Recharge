import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Map locationsTruth = Map();
Map coordsToIndex = Map();
List dataTruth = List();
List currentLocationTruth = List();
List pinAddressTruth = List();
const String apiKeyFirebase = 'AIzaSyCJhApWtsNlhMatsuOkQTMBLcsvy3S1qr8';
const String apiKeyTruth = 'AIzaSyC5Fk66xYyWRY1CLI1eL8vwboCmvoyoTDQ';

BitmapDescriptor foodIconTruth;
BitmapDescriptor drinksIconTruth;
BitmapDescriptor groceryIconTruth;

double centerMarkerOffset = 0.0049;