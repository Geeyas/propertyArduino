// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'package:flutter/material.dart';

// for making http requests
import 'package:http/http.dart' as http;
import 'package:propertyapp/properties.dart';

String accessToken = '';
String id = 'e7644871-3e83-4f1b-ae46-90312beeb40a'; // the ID of the thing
String pid = '12b6ca64-44fc-4c88-944a-d1af18666078'; // the ID of the property

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // initialsing the class
  MyData? prpData;

  //initialising the MapClass
  Map<String, dynamic> jsonData = {};

//variable for sorting A-Z
  bool _sortAscending = true;

  void _sortData() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  //function to get access token
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

//function that fetch the API // getting individual properties after receiving id and pid
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
          // fetching data from the URL
          final data = json.decode(response.body);

          // Iterating the data into key value pair
          jsonData = data;
          jsonData.forEach((key, value) {
            print('$key: $value'); // printing out the value in console
          });

          //pushing the fetched key value pair into the created class
          prpData = MyData.fromJson(jsonData);
          /////////////////////////////////////////////////////////////////////////
        } else {
          throw Exception('Failed to load properties');
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getToken();
    Future.delayed(const Duration(seconds: 5), () {
      getIndividualProperties();
    });
  }

// build widget starts from here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liquimech Propoerty Demo'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _sortAscending = !_sortAscending;
              // button for sorting A-Z
              var snackBar = SnackBar(
                content: Text(_sortAscending ? 'Sort A-Z' : 'Sort Z-A'),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              //code for sorting goes here
            },
            icon: const Icon(Icons.sort_by_alpha_rounded),
          ),
          IconButton(
            onPressed: () {
              //button to refresh the fetched data
              getIndividualProperties(); // get the individual property list by taking propoerty value and thing id value
              // getPropertiesList(); // get the property list by taking propoerty value
            },
            icon: const Icon(Icons.task),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    'Created At : \n ${prpData?.createdAt}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Href : \n ${prpData?.href}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'ID : \n ${prpData?.id}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Last value : ${prpData?.lastValue}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Name : ${prpData?.name}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Permission : ${prpData?.permission}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Persist : ${prpData?.persist}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Tag : ${prpData?.tag}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Thing ID : ${prpData?.thingId}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Thing name : ${prpData?.thingName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Type : ${prpData?.type}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Update Strategy: ${prpData?.updateStrategy}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Updated At: ${prpData?.updatedAt}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Value Updated At: ${prpData?.valueUpdatedAt}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Variable Name: ${prpData?.variableName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
