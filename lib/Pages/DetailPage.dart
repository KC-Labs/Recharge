import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:recharge/Assets/fonts.dart';
import 'package:recharge/Assets/my_flutter_app_icons.dart';
import 'package:flutter/services.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recharge/Assets/shadows.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: white, //top bar color
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Spacer(),
                    Text("McDonald's",
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'NunitoSemiBold',
                            color: white)),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 35.0),
                      child: Icon(MyFlutterApp.call, color: white, size: 30),
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
              Text("6:00 AM - 6:00 PM",
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
                  child: Text("15550 Rockfiled, Blvd, Irvine, CA 92618",
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
                        mapType: MapType.normal,
                        initialCameraPosition:
                            // ********** ADJUST CAMERA POSITIONS HERE **************
                            CameraPosition(
                          target: LatLng(33.693139, -117.789026),
                          bearing: 0,
                          tilt: 0,
                          zoom: 12,
                        ),
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
                  child: Text("Free food and drinks for medical workers, delivery workers, grocery store employees.",
                      textAlign: TextAlign.center,
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
                      // DIRECTIONS
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
