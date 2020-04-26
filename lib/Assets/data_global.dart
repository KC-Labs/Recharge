import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recharge/Assets/cloudInfo.dart';

Map locationsTruth = Map();
Map coordsToIndex = Map();
List dataTruth = List();
List currentLocationTruth = List();
List pinAddressTruth = List();

BitmapDescriptor foodIconTruth;
BitmapDescriptor drinksIconTruth;
BitmapDescriptor groceryIconTruth;

double centerMarkerOffset = 0.0049;