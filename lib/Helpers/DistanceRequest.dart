import 'dart:convert';
import 'package:http/http.dart' as http;


class DistanceRequest {
  /*
  constructor format
    origin - String ex. '41.43206,-81.38992'
    destinations - String ex. '41.43206,-81.38992|-33.86748,151.20699'
    apiKey = String
  */
  final String origin;
  final String destinations;
  final String apiKey;

  DistanceRequest({this.origin, this.destinations, this.apiKey});

  Future<List> fetchDistances() async {
    String request_link = 'https://maps.googleapis.com/maps/api/distancematrix/json?';
    request_link = request_link + 'origins=' + origin + '&destinations=' + destinations + '&key=' + apiKey;
    final response = await http.get(request_link);
    if (response.statusCode == 200) {
      return processResponse(response.body);
    } else {
      throw Exception('Failed to load distance data.');
    }
  }

  List processResponse(String jsonString) {
    print('jsonString: ' + jsonString);
    List<int> totalDistanceTimes = List<int>();
    var distance_json = jsonDecode(jsonString);
    assert(distance_json is Map);
    var distance_rows = distance_json["rows"];
    assert(distance_rows is List);
    var elements = distance_rows[0]["elements"];
    assert(elements is List);
    for (int i = 0;i < elements.length;i++) {
      totalDistanceTimes.add(elements[i]["duration"]["value"]);
    }
    return totalDistanceTimes;
  }

}