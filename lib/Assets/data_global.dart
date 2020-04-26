import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Map locationsTruth = Map();
Map coordsToIndex = Map();
List dataTruth = List();
List currentLocationTruth = List();
List pinAddressTruth = List();
const String apiKeyTruth = 'AIzaSyAwLF8Iff11hU55MulnjxMUUp3BdJfjtqs';

BitmapDescriptor foodIconTruth;
BitmapDescriptor drinksIconTruth;
BitmapDescriptor groceryIconTruth;

double centerMarkerOffset = 0.0049;