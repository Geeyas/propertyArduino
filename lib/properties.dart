// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'package:flutter/material.dart';

// for making http requests
import 'package:http/http.dart' as http;
import 'package:propertyapp/properties.dart';

String accessToken = '';
String id = 'e7644871-3e83-4f1b-ae46-90312beeb40a'; // the ID of the thing
String pid = '12b6ca64-44fc-4c88-944a-d1af18666078'; //

class MyData {
  final String createdAt;
  final String href;
  final String id;
  final String lastValue;
  final String name;
  final String permission;
  final bool persist;
  final String tag;
  final String thingId;
  final String thingName;
  final String type;
  final String updateStrategy;
  final String updatedAt;
  final String valueUpdatedAt;
  final String variableName;

  MyData({
    required this.createdAt,
    required this.href,
    required this.id,
    required this.lastValue,
    required this.name,
    required this.permission,
    required this.persist,
    required this.tag,
    required this.thingId,
    required this.thingName,
    required this.type,
    required this.updateStrategy,
    required this.updatedAt,
    required this.valueUpdatedAt,
    required this.variableName,
  });

  Future<http.Response?> getToken() async {
    var url = Uri.parse('https://api2.arduino.cc/iot/v1/clients/token');
    var response = await http.post(
      url,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': 'MMeMs4TcGZfvOpct27clCxis0wEYTjVv', //  client id
        'client_secret':
            '3XgFOMbhMwhq3tgdqCbcteAx1q09I6fa540TXZf3Fxf9YM4o8WyVOljxtEVslSK3', //  client credentials
        'audience': 'https://api2.arduino.cc/iot'
      },
    ).then(
      (response) {
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          accessToken = responseData['access_token'];
          (accessToken.toString());
          print('token received');
          return accessToken;
        } else {
          print('Error');
        }
      },
    );
  }

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      createdAt: json['created_at'],
      href: json['href'],
      id: json['id'],
      lastValue: json['last_value'],
      name: json['name'],
      permission: json['permission'],
      persist: json['persist'],
      tag: json['tag'],
      thingId: json['thing_id'],
      thingName: json['thing_name'],
      type: json['type'],
      updateStrategy: json['update_strategy'],
      updatedAt: json['updated_at'],
      valueUpdatedAt: json['value_updated_at'],
      variableName: json['variable_name'],
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late MyData myData;

//   void _parseJson(String jsonString) {
//     final jsonData = jsonDecode(jsonString);
//     myData = MyData.fromJson(jsonData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My App'),
//       ),
//       body: Center(
//         child: myData != null
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('ID: ${myData.id}'),
//                   Text('Name: ${myData.name}'),
//                   Text('Thing Name: ${myData.thingName}'),
//                   Text('Type: ${myData.type}'),
//                 ],
//               )
//             : Text('No data available'),
//       ),
//     );
//   }
// }
