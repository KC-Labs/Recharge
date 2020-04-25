import 'package:flutter/material.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:recharge/Assets/shadows.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:recharge/Assets/my_flutter_app_icons.dart';
import 'package:recharge/Pgaes/MapView.dart';
import 'package:recharge/Pgaes/LocationListView.dart';

class TabBarPage extends StatefulWidget {
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  bool isMapVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //F6F9FF
        backgroundColor: Color(0xffF6F9FF),
        body: Stack(

          children: <Widget>[
           (isMapVisible) ? MapView() : LocationListView(),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: currentWidth,
                    height: 100 * widthRatio,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius:
                            BorderRadius.all(Radius.circular(40 * widthRatio)),
                        boxShadow: barShadow),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 15 * widthRatio,
                                left: 40 * widthRatio,
                                right: 50 * widthRatio,
                                bottom: 40 * widthRatio),
                            child: SizedBox(
                              width: 40 * widthRatio,
                              height: 40 * widthRatio,
                              child: IconButton(
                                padding: EdgeInsets.only(bottom: 20 * widthRatio),
                                icon: Icon(
                                  MyFlutterApp.map,
                                  size: 35 * widthRatio,
                                  color: isMapVisible ? mainColor : lightGray
                                ),
                                onPressed: () {
                                  setState(() {
                                    isMapVisible = true;
                                  });
                                   
                                },
                              ),
                            ),
                          ),
                        ),
                          Material(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 15 * widthRatio,
                                left: 50 * widthRatio,
                                right: 40 * widthRatio,
                                bottom: 40 * widthRatio),
                            child: SizedBox(
                              width: 40 * widthRatio,
                              height: 40 * widthRatio,
                              child: IconButton(
                                padding: EdgeInsets.only(right: 10 * widthRatio, bottom: 2 * widthRatio),
                                icon: Icon(
                                  MyFlutterApp.listView,
                                  size: 25 * widthRatio,
                                  color: isMapVisible ? lightGray : mainColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isMapVisible = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))),
          ],
        ));
  }
}
