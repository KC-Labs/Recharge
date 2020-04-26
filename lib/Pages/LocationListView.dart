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

class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  SwiperController _controller;
  List<Color> colors = [green, mainColor, blue, orange];
  List<String> categories = ["All", "Food", "Drinks", "Grocery"];
  List allFood;
  List allDrinks;
  List allGroceries;
  List<int> numberOfStores;
  List<List> masterList;
  List currentList;
  DistanceRequest request;
  List timesToLocations;
  int currentPageIndex = 0;

  Future<List> _calculateDistances(List origin, List destinations) async {
    //api key manually set in global
    String origin_string = '${origin[0]},${origin[1]}';
    String destinations_string = '${destinations[0]}';
    for (int i = 1; i < destinations.length; i++) {
      destinations_string += '|${destinations[i]}';
    }
    request = DistanceRequest(
      origin: origin_string,
      destinations: destinations_string,
      apiKey: apiKeyTruth,
    );
    List<dynamic> textResponses = await request.fetchDistances();
    return textResponses;
  }

  List _calculateData() {
    List location_distances = [
      '${dataTruth[0]['latitude']},${dataTruth[0]['longitude']}'
    ];
    for (int i = 1; i < dataTruth.length; i++) {
      location_distances
          .add('${dataTruth[i]['latitude']},${dataTruth[i]['longitude']}');
    }
    return [currentLocationTruth, location_distances];
  }

  Future<List> master_calculate_distance() async {
    List calculatedData = _calculateData();

    List responses =
        await _calculateDistances(calculatedData[0], calculatedData[1]);
    return responses;
  }

  _generatLists() {
    allFood = dataTruth.where((i) => i['category'] == "Food").toList();
    allDrinks = dataTruth.where((i) => i['category'] == "Drinks").toList();
    allGroceries = dataTruth.where((i) => i['category'] == "Grocery").toList();
    numberOfStores = [
      dataTruth.length.toInt(),
      allFood.length.toInt(),
      allDrinks.length.toInt(),
      allGroceries.length.toInt()
    ];
    masterList = [dataTruth, allFood, allDrinks, allGroceries];
    print("generated list");
    if (masterList != null) {
      currentList = masterList[0];
    }
  }

  @override
  void initState() {
    super.initState();
    _generatLists();
    _controller = new SwiperController();
  }

  void _onTap(int index) {
    _controller.move(index, animation: true);

    if (currentList != null) {
      setState(() {
        currentPageIndex = index;
        currentList = masterList[index];
      });
    } 
  }

  Widget build(BuildContext context) {
    _controller.index = 0;

    return Scaffold(
        backgroundColor: Color(0xffF6F9FF),
        body: Stack(
          children: <Widget>[
            LocationList(finalList: currentList, colorIndex: currentPageIndex),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                  width: currentWidth,
                  height: 193,
                  child: FadeIn(
                      3,
                      new Swiper(
                        scale: 0.4,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 2.0, right: 2.0, top: 40, bottom: 40),
                            child: new Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: cardShadow),
                                child: Center(
                                    child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0, right: 10),
                                            child: Icon(MyFlutterApp.circle,
                                                size: 15, color: colors[index]),
                                          ),
                                          AutoSizeText(categories[index],
                                              minFontSize: 12,
                                              maxLines: 1,
                                              style: categoryHeader),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Text(
                                                  numberOfStores[index]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 45,
                                                      fontFamily: (index ==
                                                              _controller.index)
                                                          ? 'NunitoBold'
                                                          : 'NunitoRegular'))),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 9.0),
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
                        itemCount: categories.length,
                        viewportFraction: 0.36,
                        onTap: (index) {
                          _onTap(index);
                        },
                      ))),
            )
          ],
        ));
  }
}

//---------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------//

class LocationList extends StatefulWidget {
  final List finalList;
  final int colorIndex;
  const LocationList({Key key, @required this.finalList, this.colorIndex});

  @override
  _LocationListState createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  DistanceRequest request;
  List<Color> colors = [green, mainColor, blue, orange];
  List<String> categories = ["All", "Food", "Drinks", "Grocery"];
  List allFood;
  List allDrinks;
  List allGroceries;
  List<int> numberOfStores;
  List<List> masterList;
  List currentList;
  List timesToLocations;

  Future<List> _calculateDistances(List origin, List destinations) async {
    //api key manually set in global
    String origin_string = '${origin[0]},${origin[1]}';
    String destinations_string = '${destinations[0]}';
    for (int i = 1; i < destinations.length; i++) {
      destinations_string += '|${destinations[i]}';
    }
    request = DistanceRequest(
      origin: origin_string,
      destinations: destinations_string,
      apiKey: apiKeyTruth,
    );
    List<dynamic> textResponses = await request.fetchDistances();
    return textResponses;
  }

  Future<List> _calculateData() async {
    List location_distances = [
      '${widget.finalList[0]['latitude']},${widget.finalList[0]['longitude']}'
    ];
    for (int i = 1; i < widget.finalList.length; i++) {
      location_distances.add(
          '${widget.finalList[i]['latitude']},${widget.finalList[i]['longitude']}');
    }
    return [currentLocationTruth, location_distances];
  }

  Future<List> master_calculate_distance() async {
    List calculatedData = await _calculateData();
    List responses =
        await _calculateDistances(calculatedData[0], calculatedData[1]);
    //setState(() {
    //  timesToLocations = responses;
    // });
    return responses;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: master_calculate_distance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
                padding: EdgeInsets.only(top: 160),
                child: Container(
                    width: currentWidth,
                    height: 650,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 700,
                        ),
                        child: ListView.builder(
                            itemCount: widget.finalList.length, // array.count,
                            itemBuilder: (BuildContext context, int index) {
                              //index variable
                              return FadeIn(
                                  (index < 3) ? (index + 1) * 0.5 + 5 : 0,
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 14, 30, 14),
                                      child: RaisedButton(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 20, 10, 20),
                                          elevation: 14,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15 * widthRatio)),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 15.0,
                                                          right: 10),
                                                      child: Icon(
                                                          MyFlutterApp.circle,
                                                          size: 15,
                                                          color: colors[widget
                                                              .colorIndex]),
                                                    ),
                                                    AutoSizeText(
                                                        widget.finalList[index]
                                                            ['name'], // name,
                                                        minFontSize: 12,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            color: black,
                                                            fontFamily:
                                                                'NunitoSemiBold')),
                                                    Spacer(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20.0),
                                                      child: Text(
                                                          "Open now", //time calculation isOpen(currentTime DateTime)
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'NunitoRegular',
                                                              color: green)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18.0),
                                                    child: Icon(
                                                        (index % 2 == 0)
                                                            ? MyFlutterApp.food
                                                            : MyFlutterApp
                                                                .drinks, //category of the business
                                                        size: 15,
                                                        color: gray),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0, right: 20),
                                                    child: Text(
                                                        widget.finalList[index][
                                                            'category'], // category of business
                                                        style: TextStyle(
                                                            color: gray,
                                                            fontFamily:
                                                                'NunitoRegular',
                                                            fontSize: 16 *
                                                                widthRatio)),
                                                  ),
                                                  FutureBuilder(
                                                    future:
                                                        master_calculate_distance(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (snapshot.hasData) {
                                                          return Text(
                                                              "${snapshot.data[index]}",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'NunitoRegular',
                                                                  color: gray));
                                                        }
                                                      } else {
                                                        return SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                                CircularProgressIndicator());
                                                      }
                                                      return Container();
                                                    },
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18.0,
                                                        top: 15,
                                                        bottom: 15),
                                                    child: Text(
                                                        widget.finalList[index]
                                                            ['summary'],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: black,
                                                            fontFamily:
                                                                "NunitoRegular")),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5.0, bottom: 7),
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 18.0,
                                                          right: 10),
                                                      child: Text("Details",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: gray,
                                                              fontFamily:
                                                                  "NunitoSemiBold")),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10.0),
                                                      child: Icon(
                                                          Icons.arrow_forward,
                                                          size: 20,
                                                          color: gray),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) => DetailPage(
                                                        name: widget.finalList[
                                                            index]['name'],
                                                        offerings: widget
                                                                .finalList[index]
                                                            ['offerings'],
                                                        openTime: widget
                                                                .finalList[
                                                            index]['open_time'],
                                                        closeTime: widget
                                                                .finalList[index]
                                                            ['close_time']))); //present next screen
                                          })));
                            }))));
          }
        });
  }
}
