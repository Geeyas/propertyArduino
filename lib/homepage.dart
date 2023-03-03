import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:propertyapp/properties.dart';

// for making http requests
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

String accessToken = '';
String id = 'e7644871-3e83-4f1b-ae46-90312beeb40a';
String pid = '12b6ca64-44fc-4c88-944a-d1af18666078';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
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
      'client_id': '11BPBTVoGudlcJ8408X6HpTLYXGyEuJ1', //  client id
      'client_secret':
          'XJJ1N3B1BpggeI5qSpF3K3t6kYSa482Ry2lNe7ofcA0o71hTpIqgh1Nn883IHnIs', //  client credentials
      'audience': 'https://api2.arduino.cc/iot'
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        accessToken = responseData['access_token'];
        print(accessToken);
        return accessToken;
      } else {
        print('Error');
      }
    },
  );
}

Future<http.Response?> getProperties() async {
  var url = Uri.parse(
      'https://api2.arduino.cc/iot/v2/things/e7644871-3e83-4f1b-ae46-90312beeb40a/properties/12b6ca64-44fc-4c88-944a-d1af18666078');
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
        var data = json.decode(response.body);
        print(data); // print response after JSON conversion
      } else {
        throw Exception('Failed to load properties');
      }
    },
  );
}
