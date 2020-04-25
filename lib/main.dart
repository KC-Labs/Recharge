import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// custom modules
import 'DistanceRequest.dart';
import 'MapView.dart';


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
  print('Firebaseapp initialized.');
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyHomePage(title: 'Flutter Demo Home Page', app: app),
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
  int _counter = 0;
  int _testSeconds;

  DatabaseReference locationsRef;

  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    database.reference().child('test_locations').once().then((DataSnapshot snapshot) {
      print('Connected to database and fetched ${snapshot.value}');
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MapView(),
    );
  }
}
