import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:recharge/Assets/my_flutter_app_icons.dart';
import 'package:recharge/Assets/shadows.dart';
import 'package:recharge/Assets/fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {

  SwiperController _controller;
  @override
  void initState() {
    super.initState();
    _controller = new SwiperController();
  }

  void _onTap(int index) {
    _controller.move(index, animation: true);
  }

  Widget build(BuildContext context) {
    _controller.index = 0;
    return Scaffold(
     backgroundColor: Color(0xffF6F9FF),
     body: Stack(
       children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Container(
              width: currentWidth,
      height: 193,
            child: new Swiper(
  itemBuilder: (BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 2.0, right: 2.0, top: 40, bottom: 40),
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: cardShadow
          
        ),
        child: Center(child: 
       //(index == _controller.index) ? 
       Column(
         children: <Widget>[
           Padding(
             padding: EdgeInsets.only(top: 15.0),
             child: Row(
               children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(left: 15.0, right: 10),
                   child: Icon(MyFlutterApp.circle, size: 15),
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
                   child: Text((index == _controller.index) ?  "7" : "3", style: TextStyle(fontSize: 45, fontFamily: (index == _controller.index) ?   'NunitoBold' : 'NunitoRegular')),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(left: 9.0),
                   child: Text("loactions \nfound", maxLines: 2, textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontFamily: 'NunitoLight')),
                 ),
               ],
             ),
           ),
         ],
       ) 
      /* : 
       Column(
         children: <Widget>[
           Padding(
             padding: EdgeInsets.only(top: 15.0),
             child: Row(
               children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(left: 15.0, right: 10),
                   child: Icon(MyFlutterApp.circle, size: 15),
                 ),
                 AutoSizeText("Not Selected", 
                 minFontSize: 12,
                 maxLines: 1,
                 style: categoryHeader),
               ],
             ),
           ),
           Padding(padding: EdgeInsets.only(top: 5),
           child: 
           Text("3 locations", style: TextStyle(fontFamily: 'NunitoLight', fontSize: 15))
           )
        
          
         ],
       )
       */
       )
        ),
    );
  },
  controller: _controller,
  loop: false,
  itemCount: 4,
  viewportFraction: 0.36,
  scale: 0.35,
  onTap: (index) {
   
    _onTap(index);
  },

),
          ),
        )
       ],
     )
    );
  }
}