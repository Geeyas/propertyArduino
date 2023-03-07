// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'package:flutter/material.dart';

// for making http requests
import 'package:http/http.dart' as http;
import 'package:propertyapp/properties.dart';

String accessToken = '';
String id = 'e7644871-3e83-4f1b-ae46-90312beeb40a'; // the ID of the thing
String pid = '12b6ca64-44fc-4c88-944a-d1af18666078'; // the ID of the property

// Map property = ;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liquimech Propoerty Demo'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                getToken();
                const snackBar = SnackBar(
                  content: Text('Token received'),
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const Icon(Icons.token)),
          IconButton(
              onPressed: () {
                // getProperties();
                // fetchPropertiesList();
                getPropertiesList();
              },
              icon: const Icon(Icons.task))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: const [],
      )),
    );
  }
}

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

// getting individual properties after receiving id and pid
Future<http.Response?> getIndividualProperties() async {
  // await getToken();
  var url =
      Uri.parse('https://api2.arduino.cc/iot/v2/things/$id/properties/$pid');
  var response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        print('createdAt: ' + data['created_at']);
        print('href: ' + data['href']);
        print('id: ' + data['id']);
        print('lastValue: ' + data['last_value']);
        print('name: ' + data['name']);
        print('permission: ' + data['permission']);
        print('persist: ' + data['persist'].toString());
        print('tag: ' + data['tag'].toString());
        print('thingId: ' + data['thing_id']);
        print('thingName: ' + data['thing_name']);
        print('type: ' + data['type']);
        print('updatedStrategy: ' + data['update_strategy']);
        print('updatedAt: ' + data['updated_at']);
        print('valueUpdatedAt: ' + data['value_updated_at']);
        print('variableName: ' + data['variable_name']);

        MyData prpData = MyData(
            createdAt: data['created_at'],
            href: data['href'],
            id: data['id'],
            lastValue: data['last_value'],
            name: data['name'],
            permission: data['permission'],
            persist: data['persist'],
            tag: data['tag'].toString(),
            thingId: data['thing_id'],
            thingName: data['thing_name'],
            type: data['type'],
            updateStrategy: data['update_strategy'],
            updatedAt: data['updated_at'],
            valueUpdatedAt: data['value_updated_at'],
            variableName: data['variable_name']);
      } else {
        throw Exception('Failed to load properties');
      }
    },
  );
}

//getting properties list from the arduino cloud
Future<http.Response?> getPropertiesList() async {
  // await getToken();
  var url = Uri.parse('https://api2.arduino.cc/iot/v2/things/$id/properties');

  var response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        print(data); // print response after JSON conversion
      } else {
        throw Exception('Failed to load properties');
      }
    },
  );
}
