//import 'dart:html';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PropertyData {
  String propertyName;
  String propertyWidget;
  dynamic apiResponse;

  PropertyData(
      {this.propertyName = "", this.propertyWidget = "", this.apiResponse});

  factory PropertyData.fromJson(Map<String, dynamic> json) {
    return PropertyData(
      propertyName: json['propertyName'] ?? "",
      propertyWidget: json['propertyWidget'] ?? "",
      apiResponse: json['apiResponse'],
    );
  }
}

Future<List<PropertyData>> iterateMapAndRetrieveValues(
    Map<int, Map<String, dynamic>> data) async {
  List<PropertyData> results = [];

  for (int index in data.keys) {
    Map<String, dynamic>? map = data[index];
    String propertyId = map!['property_id'];
    String thingId = map['thing_id'];

    String apiUrl =
        "https://api2.arduino.cc/iot/v2/things/$propertyId/properties/$thingId";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      PropertyData propertyData = PropertyData.fromJson({
        'propertyName': map['property_name'],
        'propertyWidget': map['property_widget'],
        'apiResponse': json.decode(response.body),
      });
      results.add(propertyData);
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  return results;
}
