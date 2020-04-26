import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:recharge/Assets/fonts.dart';
import 'package:recharge/Assets/my_flutter_app_icons.dart';
import 'package:flutter/services.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recharge/Assets/shadows.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:recharge/Assets/data_global.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';


class DetailListPage extends StatefulWidget {
  final String name;
  final String offerings;
  final int openTime;
  final int closeTime;
  final LatLng coords;
  final String category;
  final LatLng markerCoords;
  

  DetailListPage(
      {Key key,
      @required this.name,
      this.offerings,
      this.openTime,
      this.closeTime,
      this.coords,
      this.category,
      this.markerCoords,
      })
      : super(key: key);
  @override
  _DetailListPageState createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {

  String _displayAddress;

  final Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

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

  void processStringAddress() async {
    String address = await _coordToAddress("${widget.coords.latitude},${widget.coords.longitude}");
    setState(() {
      _displayAddress = address;
    });
  }

  @override
  void initState() {
    super.initState();
    processStringAddress();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: white, //top bar color
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
  }

  Future<String> _coordToAddress(String coordinates) async {
    String request_link = 'https://maps.googleapis.com/maps/api/geocode/json?';
    request_link = request_link + 'latlng=' + coordinates + '&key=' + apiKeyTruth;
    final response = await http.get(request_link);
    if (response.statusCode == 200) {
      var raw_return = jsonDecode(response.body);
      print('raw_return');
      print(raw_return);
      var formatted_address = raw_return["results"][0]["formatted_address"];
      return formatted_address;
    } else {
      throw Exception('Failed to load distance data.');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [mainColor, secondaryColor])),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: white, size: 30),
                        onPressed: () {
                          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: white, //top bar color
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness:
            Brightness.light // Dark == white status bar -- for IOS.
        ));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Spacer(),
                    Text(widget.name,
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'NunitoSemiBold',
                            color: white)),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 25.0),
                      child: IconButton(icon: Icon(MyFlutterApp.call, color: white, size: 30),
                      onPressed: () {
                        // implement call
                      },),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 10),
                child: Text(
                  "Hours",
                  style: TextStyle(
                      fontSize: 22, fontFamily: "NunitoBold", color: white),
                ),
              ),
              Text(_hours(widget.openTime, widget.closeTime),
                  style: TextStyle(
                      fontSize: 24, fontFamily: "NunitoRegular", color: white)),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 10),
                child: Text(
                  "Location",
                  style: TextStyle(
                      fontSize: 22, fontFamily: "NunitoBold", color: white),
                ),
              ),
              SizedBox(
                  width: currentWidth * 0.6,
                  child: Text((_displayAddress != null ? _displayAddress : "Loading Address..."),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 19,
                          fontFamily: "NunitoRegular",
                          color: white))),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    width: 136,
                    height: 136,
                    decoration: BoxDecoration(
                        color: gray,
                        borderRadius: BorderRadius.all(Radius.circular(68)),
                        border: Border.all(color: white, width: 5)),
                    child: ClipOval(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: widget.coords,
                          bearing: 0,
                          tilt: 0,
                          zoom: 12,
                        ),
                        mapType: MapType.normal,
                        rotateGesturesEnabled: false, 
                        scrollGesturesEnabled: false, 
                        zoomControlsEnabled: false, 
                        zoomGesturesEnabled: false, 
                        tiltGesturesEnabled: false,
                        myLocationButtonEnabled: false,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);

                          setState(() {
                            _markers.add(
                              Marker(
                                markerId: MarkerId('focusMarker'),
                                position: widget.markerCoords,
                                icon: widget.category == "Food" ? foodIconTruth : (widget.category == "Drinks" ? drinksIconTruth : groceryIconTruth),
                              )
                            );
                          });
                        },
                      ),
                    ),
                  )),
             Padding(
                padding: EdgeInsets.only(top: 40, bottom: 10),
                child: Text(
                  "Offerings",
                  style: TextStyle(
                      fontSize: 22, fontFamily: "NunitoBold", color: white),
                ),
              ),
              SizedBox(
                  width: currentWidth * 0.75,
                  child: AutoSizeText(widget.offerings,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      minFontSize: 12,
                      style: TextStyle(
                          fontSize: 19,
                          
                          fontFamily: "NunitoRegular",
                          color: white))), 
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.55 * widthRatio,
                  height: 70 * widthRatio,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: buttonShadow,
                   
                    borderRadius:
                        BorderRadius.all(Radius.circular(35 * widthRatio)),
                  ),
                  child: FlatButton(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(35))),
                    onPressed: () {
                      MapsLauncher.launchQuery(_displayAddress);
                    },
                    child: Center(
                      child: Text(
                        'Directions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'NunitoBold',
                            fontSize: 18 * widthRatio,
                            color: black),
                      ),
                    ),
                  ),
                ),
              ),      
            ],
          ),
        ));
  }
}