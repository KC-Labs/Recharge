import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:recharge/Assets/locations.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:recharge/Assets/my_flutter_app_icons.dart';
import 'package:recharge/Assets/shadows.dart';
import 'package:recharge/Assets/fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:recharge/Helpers/FadeIn.dart';
import 'package:recharge/Pages/DetailPage.dart';


class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {

  SwiperController _controller;
  SwiperController _verticalController;
  List<Color> colors = [mainColor, blue, orange];

  @override
  void initState() {
    super.initState();
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
          Padding(
          padding: EdgeInsets.only(top: 160),
          child: Container(
              width: currentWidth,
      height: 650,
            child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 700,),
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
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
                                    AutoSizeText("McDonald's",
                                        minFontSize: 12,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 22, color: black, fontFamily: 'NunitoSemiBold')),
                                        Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text("Open Now", style: TextStyle(fontSize: 12, fontFamily: 'NunitoRegular', color: green)),
                                  )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 18.0),
                                        child: Icon((index % 2 == 0) ? MyFlutterApp.food : MyFlutterApp.drinks, size: 15, color: gray),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0, right: 20),
                                        child: Text(
                                            (index % 2 == 0) ? "Food" : "Drinks",
                                            style: TextStyle(
                                                color: gray,
                                                fontFamily: 'NunitoRegular',
                                                fontSize: 16 * widthRatio)),
                                      ),
                                      Text("${(0.6 * (index+1)).toStringAsPrecision(2)} miles", style: TextStyle(fontSize: 13, fontFamily: 'NunitoRegular', color: gray)),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 18.0, top: 15, bottom: 15),
                                        child: Text("Offers: Free food & drinks.", style: TextStyle(fontSize: 17, color: black, fontFamily: "NunitoRegular")),
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
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailPage()));
                              }
                              )));
                           
                        }
                      )
                      )
            )),
          
        
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