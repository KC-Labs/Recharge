import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:recharge/Pages/TabBarPage.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:recharge/Assets/colors.dart';


import 'package:recharge/Helpers/DistanceRequest.dart';
import 'package:recharge/Assets/data_global.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String name = 'recharge';
  FirebaseOptions options = const FirebaseOptions(
    googleAppID: '1:754665357402:ios:d8d5c9873297796c589863',
    gcmSenderID: '754665357402',
    apiKey: apiKeyFirebase,
    databaseURL: 'https://recharge-38fab.firebaseio.com',
  );
  final FirebaseApp app = await FirebaseApp.configure(
      name: name, 
      options: options,
  );
  print('Firebaseapp initialized.');
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


  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: white, //top bar color
          statusBarIconBrightness:
            Brightness.light,
          statusBarBrightness:  Brightness.light // Dark == white status bar -- for IOS.
          ));
  }
  /*
  void _testMaps() async {
    String apiKey = 'AIzaSyAwLF8Iff11hU55MulnjxMUUp3BdJfjtqs';
    DistanceRequest test_request = DistanceRequest(
      apiKey: apiKey,
      origin: '33.688789,-117.707609',
      destinations: '33.672206,-117.714971',
    );
    List distances = await test_request.fetchDistances();
    setState(() {
      _testSeconds = distances[0];
    });
  }
  */
  @override
  Widget build(BuildContext context) {
    //initializing global variables to enable auto layout
    currentWidth = MediaQuery.of(context).size.width;
    currentHeight = MediaQuery.of(context).size.height;
    widthRatio = MediaQuery.of(context).size.width / 375.0;
    heightRatio = MediaQuery.of(context).size.height / 812.0;

    return TabBarPage(
      app: widget.app,
    );
  }
}
