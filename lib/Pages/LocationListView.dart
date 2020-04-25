import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:recharge/Assets/locations.dart';
import 'package:recharge/Assets/device_ratio.dart';
import 'package:recharge/Assets/shadows.dart';


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
    return Scaffold(
     backgroundColor: Color(0xffF6F9FF),
     body: Stack(
       children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Container(
              width: currentWidth,
      height: 183,
            child: new Swiper(
  itemBuilder: (BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 40, bottom: 40),
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: cardShadow
          
        ),
        child: Center(child: 
       Container()
       )
        ),
    );
  },
  controller: _controller,
  loop: false,
  itemCount: 4,
  viewportFraction: 0.4,
  scale: 0.4,
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