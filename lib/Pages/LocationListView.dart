import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:recharge/Assets/my_flutter_app_icons.dart';
import 'package:recharge/Assets/shadows.dart';
import 'package:recharge/Assets/fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:recharge/Helpers/FadeIn.dart';
import 'package:recharge/Pages/DetailPage.dart';
import 'package:recharge/Assets/data_global.dart';
import 'package:recharge/Helpers/DistanceRequest.dart';
import 'dart:convert';


class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {

  SwiperController _controller;
  SwiperController _verticalController;
  List<Color> colors = [mainColor, blue, orange];

  DistanceRequest request;
  List timesToLocations;

  Future<List> _calculateDistances(List origin, List destinations) async {
    //api key manually set in global
    String origin_string = '${origin[0]},${origin[1]}';
    String destinations_string = '${destinations[0]}';
    for (int i=1;i<destinations.length;i++) {
      destinations_string += '|${destinations[i]}';
    }
    print('origin_string');
    print(origin_string);
    print('destinations_string');
    print(destinations_string);
    request = DistanceRequest(
      origin: origin_string,
      destinations: destinations_string,
      apiKey: apiKeyTruth,
    );
    List<dynamic> textResponses = await request.fetchDistances();
    return textResponses;
  }
  
  Future<List> _calculateData() async {
    List location_distances = ['${dataTruth[0]['latitude']},${dataTruth[0]['longitude']}'];
    for (int i=1;i<dataTruth.length;i++) {
      location_distances.add('${dataTruth[i]['latitude']},${dataTruth[i]['longitude']}');
    }
    return [currentLocationTruth, location_distances];
  }


  Future<List> master_calculate_distance() async {
    List calculatedData = await _calculateData();
    List responses = await _calculateDistances(calculatedData[0], calculatedData[1]);
    //setState(() {
    //  timesToLocations = responses;
   // });
   return responses;
  }
  
  @override
  void initState() {
    super.initState();
   master_calculate_distance();
    _controller = new SwiperController();
    _verticalController = new SwiperController();
  }

  void _onTap(int index) {
    _controller.move(index, animation: true);
  }

  void _verticalOnTap(int index) {
    _verticalController.move(index, animation: true);
  }

  Widget build(BuildContext context) {
    _controller.index = 0;
    _verticalController.index = 0;
    return Scaffold(
     backgroundColor: Color(0xffF6F9FF),
     body: Stack(
       children: <Widget>[
          FutureBuilder(
                        future: master_calculate_distance(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == false) {
                            return Center(child: CircularProgressIndicator());
                          }
                      else {
                           return Padding(
          padding: EdgeInsets.only(top: 160),
          child: Container(
              width: currentWidth,
      height: 650,
            child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 700,),
                      child:  ListView.builder(
                        itemCount: dataTruth.length, // array.count,
                        itemBuilder: (BuildContext context, int index) {
                          //index variable 
                           return FadeIn(
                             (index < 3) ?
                             (index + 1) * 0.5 + 3 :
                             0, 
                             
                             Padding(
                            padding: const EdgeInsets.fromLTRB(30, 14, 30, 14),
                            child: RaisedButton(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                              elevation: 14,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15 * widthRatio)),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                         Padding(
                                      padding:
                                          EdgeInsets.only(left: 15.0, right: 10),
                                      child: Icon(MyFlutterApp.circle, size: 15, color: colors[index % 3]),
                                    ),
                                    AutoSizeText(dataTruth[index]["name"],  // name,
                                        minFontSize: 12,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 22, color: black, fontFamily: 'NunitoSemiBold')),
                                        Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text("Open Now", //time calculation isOpen(currentTime DateTime)
                                     style: TextStyle(fontSize: 12, fontFamily: 'NunitoRegular', color: green)),
                                  )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 18.0),
                                        child: Icon( (index % 2 == 0) ? MyFlutterApp.food : MyFlutterApp.drinks,  //category of the business
                                        size: 15, color: gray),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0, right: 20),
                                        child: Text(
                                            dataTruth[index]["category"], // category of business
                                            style: TextStyle(
                                                 color: gray,
                                                fontFamily: 'NunitoRegular',
                                                fontSize: 16 * widthRatio)),
                                      ),
                                      FutureBuilder(
                                        future: master_calculate_distance(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            if (snapshot.hasData) {
                                              return   Text(
                                        "${snapshot.data[index]}",
                                         style: TextStyle(fontSize: 13, fontFamily: 'NunitoRegular', color: gray));
                                            }
                                          } else {
                                            return SizedBox(
                                              width: 20, height: 20,
                                              child: CircularProgressIndicator());
                                          }
                                            return Container();
                                        },
                                      )
                                    
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 18.0, top: 15, bottom: 15),
                                        child: Text(dataTruth[index]["summary"], style: TextStyle(fontSize: 17, color: black, fontFamily: "NunitoRegular")),
                                      ),
                                    ],
                                  ),
                                   Padding(
                                     padding: EdgeInsets.only(top: 5.0, bottom: 7),
                                     child: Row(
                                      children: <Widget>[
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(left: 18.0, right: 10),
                                          child: Text("Details", style: TextStyle(fontSize: 16, color: gray, fontFamily: "NunitoSemiBold")),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Icon(Icons.arrow_forward, size: 20, color: gray),
                                        )

                                      ],
                                  ),
                                   )
                                ],
                                
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailPage(
                                  name: dataTruth[index]['name'],
                                  offerings: dataTruth[index]['offerings'],
                                  openTime: dataTruth[index]['open_time'],
                                  closeTime: dataTruth[index]['close_time'],
                                  address: pinAddressTruth[index],
                                ))); //present next screen
                              }
                              )));
                           
                        }
                      )
                      
                     
                      
                     
                      )
            ));
                        } 
                      }),
          
          
        
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Container(
              width: currentWidth,
      height: 193,
            child: FadeIn(3, new Swiper(
                  scale: 0.4,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 2.0, right: 2.0, top: 40, bottom: 40),
                      child: new Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: cardShadow),
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 15.0, right: 10),
                                      child: Icon(MyFlutterApp.circle, size: 15, color: colors[index % 3]),
                                    ),
                                    AutoSizeText("Selected",
                                        minFontSize: 12,
                                        maxLines: 1,
                                        style: categoryHeader),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25.0),
                                      child: Text(
                                          (index == _controller.index)
                                              ? "7"
                                              : "3",
                                          style: TextStyle(
                                              fontSize: 45,
                                              fontFamily:
                                                  (index == _controller.index)
                                                      ? 'NunitoBold'
                                                      : 'NunitoRegular')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 9.0),
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
                  controller: _controller,
                  loop: false,
                  itemCount: 4,
                  viewportFraction: 0.36,
                  onTap: (index) {
                    _onTap(index);
                  },
                ))
          ),
        ),
       
       ],
     )
    );
  }
}