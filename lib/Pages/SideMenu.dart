import 'package:flutter/material.dart';
import 'package:recharge/Assets/colors.dart';
import 'package:recharge/Assets/my_flutter_app_icons.dart';


class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            curve: Curves.easeInOut,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10),),
                Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(MyFlutterApp.icon_logo, size: 50, color: white),
                ),
                   Padding(
                     padding: EdgeInsets.only(left: 10.0),
                     child: Text(
                  'Recharge',
                  style: TextStyle(color: white, fontSize: 36, fontFamily: 'NunitoBold'),
                ),
                   ),
                ],),
                Padding(
                  padding: EdgeInsets.only(left: 25, top: 20),
                  child: Text("Supporting all essential workers fighting COVID-19.", style: TextStyle(color: white, fontSize: 15, fontFamily: 'NunitoBold')),
                )
              ],
            ),
           
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [secondaryColor, mainColor], begin: Alignment.topLeft, end: Alignment.topRight ),
          
                
                    ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 40, top: 30),
            title: Text('Home', style: TextStyle(fontSize: 20, fontFamily: 'NunitoLight')),
            onTap: () => {

            },
          ),
           ListTile(
            contentPadding: EdgeInsets.only(left: 40),
            title: Text('About', style: TextStyle(fontSize: 20, fontFamily: 'NunitoLight')),
            onTap: () => {

            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 40),
            title: Text('Add to Our Map', style: TextStyle(fontSize: 20, fontFamily: 'NunitoLight')),
            onTap: () => {

            },
          ),
         ListTile(
            contentPadding: EdgeInsets.only(left: 40),
            title: Text('COVID-19 Tally', style: TextStyle(fontSize: 20, fontFamily: 'NunitoLight')),
            onTap: () => {

            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 40),
            title: Text('Settings', style: TextStyle(fontSize: 20, fontFamily: 'NunitoLight')),
            onTap: () => {

            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 25, top: 200),
            leading: IconButton(icon: Icon(Icons.arrow_back, size: 50, color: black), onPressed: () {
            Navigator.pop(context);
          },),
            onTap: () => {

            },
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(left: 40, top: 0),
            title: Text('Back', style: TextStyle(fontSize: 20, fontFamily: 'NunitoLight')),
            onTap: () => {

            },
          ),
        ],
      ),
    );
  }
}