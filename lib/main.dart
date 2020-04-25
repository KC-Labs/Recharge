import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:recharge/Pgaes/TabBarPage.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:recharge/Assets/colors.dart';


// custom modules

import 'package:recharge/Helpers/DistanceRequest.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String name = 'recharge';
  FirebaseOptions options = const FirebaseOptions(
    googleAppID: '1:883446079368:ios:80f7c413ad4115050e243d',
    gcmSenderID: '883446079368',
    apiKey: 'AIzaSyAwLF8Iff11hU55MulnjxMUUp3BdJfjtqs',
    databaseURL: 'https://recharge-aeb50.firebaseio.com',
  );
  final FirebaseApp app = await FirebaseApp.configure(
      name: name, 
      options: options,
  );
  print('Firebase app initialized.');
  runApp(MaterialApp(
    title: 'Recharge',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: MyHomePage(title: 'Recharge', app: app),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.app}) : super(key: key);
  final FirebaseApp app;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference locationsRef;
  List locationsDescriptions = List();
  Map locations = Map();

  void initState() {
    super.initState();
    // fetch data from realtime database
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    database.reference().child('locations').once().then((DataSnapshot snapshot) {
      print('Connected to database and fetched ${snapshot.value}');
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
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: white, //top bar color
      statusBarIconBrightness:
        Brightness.light,
      statusBarBrightness:  Brightness.light // Dark == white status bar -- for IOS.
    ));
  }


  @override
  Widget build(BuildContext context) {

    //initializing global variables to enable auto layout
    currentWidth = MediaQuery.of(context).size.width;
    currentHeight = MediaQuery.of(context).size.height;
    widthRatio = MediaQuery.of(context).size.width / 375.0;
    heightRatio = MediaQuery.of(context).size.height / 812.0;

    return TabBarPage();

  }
}
