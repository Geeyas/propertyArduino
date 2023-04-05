// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'package:flutter/material.dart';

// for making http requests
import 'package:http/http.dart' as http;
import 'package:propertyapp/properties.dart';

String accessToken = '';
// Geeyas
String idG = 'e7644871-3e83-4f1b-ae46-90312beeb40a'; // the ID of the thing
String pidG = '12b6ca64-44fc-4c88-944a-d1af18666078'; // the ID of the property
// // Aayush
// String idA = 'ea726baa-f244-495a-b70d-b779be76268f'; // the ID of the thing
// String pidA = '722dc691-60e2-4615-bcc9-97c1ec0f0085'; // the ID of the property
// // Fred
// String idF = 'd8f9d16e-7824-42fa-9acf-4e993d5618ee'; // the ID of the thing
// String pidF = '88b3ac14-5673-4c62-b816-bb4156a543e6'; // the ID of the property

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyData? prpData; // initialsing the class
  Map<String, dynamic> jsonData = {}; //initialising the MapClass
  List<dynamic> dataList = jsonDecode(sampleProp); //decoding the JSON array
  bool isAscending = true; // for sorting

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
    var url = Uri.parse(
        'https://api2.arduino.cc/iot/v2/things/$idG/properties/$pidG');
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
  }

// function to sort the array
  void _sortList() {
    setState(() {
      if (isAscending) {
        dataList.sort((a, b) => a['name'].compareTo(b['name']));
      } else {
        dataList.sort((a, b) => b['name'].compareTo(a['name']));
      }
      isAscending = !isAscending;
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
              _sortList();
            },
            icon: const Icon(Icons.sort_by_alpha),
            tooltip: 'Sorting by Ascending or Descending order',
          ),
        ],
      ),
      body: ListView.builder(
        //// this price of code is to fetch the data from the API for individual property and display it into the display widget
        // itemCount: jsonData.length,
        // itemBuilder: (BuildContext context, int index) {
        //   String key = jsonData.keys.elementAt(index);
        //   // String key = sortedKeys[index];
        //   dynamic value = jsonData[key];
        //   return Card(
        //     child: ListTile(
        //       title: Text(key),
        //       subtitle: Text(value.toString()),
        //       // Currently Data has been fetched directly from cloud after running API (has not been fethced from the class but data has been already pushed to the class)
        //       // if Data need to be fetched from the class =>>>> '${prpData?.thingName}' <<<<= use this dynamic syntax
        //     ),
        //   );
        // },
        ////////////////////////////////////////////////////////////////////
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          // final sortedItems = isAscending ? dataList.toList() : dataList;
          final Map<String, dynamic> itemdata = dataList[index];
          final String name = itemdata['name'];
          final String id = itemdata['id'];
          final String tag = itemdata['tag'];
          final String thingName = itemdata['thingName'];
          final String type = itemdata['type'];
          final String createdAt = itemdata['createdAt'];
          final String href = itemdata['href'];
          return ListTile(
            title: Text(name),
            subtitle: Text(
                '$id \n $tag \n $thingName \n $type \n $createdAt \n $href \n'),
            trailing: DropdownButton(
              items: ['name', 'tag', 'type'].map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue == 'name') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String newName = '';
                        return AlertDialog(
                          title: const Text('Update Name'),
                          content: TextField(
                            autofocus: true,
                            onChanged: (value) {
                              newName = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Void'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Save'),
                              onPressed: () {
                                setState(() {
                                  dataList[index]['name'] = newName;
                                });
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                } else if (newValue == 'tag') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String newTag = '';
                        return AlertDialog(
                          title: const Text('Update Tag'),
                          content: TextField(
                            autofocus: true,
                            onChanged: (value) {
                              newTag = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Void'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Save'),
                              onPressed: () {
                                // code that will update the name of the property that has been clicked
                                setState(() {
                                  dataList[index]['tag'] = newTag;
                                });
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                } else if (newValue == 'type') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String newType = '';
                        return AlertDialog(
                          title: const Text('Update Tag'),
                          content: TextField(
                            autofocus: true,
                            autofillHints: const <String>[
                              'number, String, boolean'
                            ],
                            onChanged: (value) {
                              newType = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Void'),
                            ),
                            TextButton(
                              child: const Text('Save'),
                              onPressed: () {
                                setState(() {
                                  dataList[index]['type'] = newType;
                                });
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                }
              },
            ),
          );
        },
      ),
    );
  }
}

//getting properties list from the arduino cloud
Future<http.Response?> getPropertiesList() async {
  // await getToken();
  var url = Uri.parse('https://api2.arduino.cc/iot/v2/things/$idG/properties');

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

const sampleProp = ''' [
  {
    "createdAt": "2023-03-22T12:00:00Z",
    "href": "/api/things/1234/variables/5678",
    "id": "5678",
    "lastValue": "42",
    "name": "temperature",
    "permission": "read-write",
    "persist": true,
    "tag": "sensor",
    "thingId": "1234",
    "thingName": "thermostat",
    "type": "number",
    "updateStrategy": "on-change",
    "updatedAt": "2023-03-22T12:01:00Z",
    "valueUpdatedAt": "2023-03-22T12:01:00Z",
    "variableName": "temperature"
  },
  {
    "createdAt": "2023-03-22T12:00:00Z",
    "href": "/api/things/1234/variables/7890",
    "id": "7890",
    "lastValue": "false",
    "name": "power",
    "permission": "read-write",
    "persist": true,
    "tag": "switch",
    "thingId": "1234",
    "thingName": "thermostat",
    "type": "boolean",
    "updateStrategy": "on-change",
    "updatedAt": "2023-03-22T12:01:00Z",
    "valueUpdatedAt": "2023-03-22T12:01:00Z",
    "variableName": "power"
  },
  {
    "createdAt": "2022-01-01T12:00:00Z",
    "href": "https://example.com/some-resource",
    "id": "123",
    "lastValue": "42",
    "name": "someName",
    "permission": "read-write",
    "persist": true,
    "tag": "someTag",
    "thingId": "456",
    "thingName": "someThing",
    "type": "integer",
    "updateStrategy": "merge",
    "updatedAt": "2022-01-01T13:00:00Z",
    "valueUpdatedAt": "2022-01-01T13:00:00Z",
    "variableName": "someVariable"
  },
  {
    "createdAt": "2022-02-01T12:00:00Z",
    "href": "https://example.com/another-resource",
    "id": "456",
    "lastValue": "true",
    "name": "anotherName",
    "permission": "read-only",
    "persist": false,
    "tag": "anotherTag",
    "thingId": "789",
    "thingName": "anotherThing",
    "type": "boolean",
    "updateStrategy": "replace",
    "updatedAt": "2022-02-01T13:00:00Z",
    "valueUpdatedAt": "2022-02-01T13:00:00Z",
    "variableName": "anotherVariable"
  },
   {
      "createdAt": "2023-03-22T13:00:00Z",
      "href": "/api/things/1234/variables/5679",
      "id": "5679",
      "lastValue": "true",
      "name": "motion_detected",
      "permission": "read-write",
      "persist": true,
      "tag": "sensor",
      "thingId": "1234",
      "thingName": "motion_sensor",
      "type": "boolean",
      "updateStrategy": "on-change",
      "updatedAt": "2023-03-22T13:01:00Z",
      "valueUpdatedAt": "2023-03-22T13:01:00Z",
      "variableName": "motion_detected"
    },
    {
      "createdAt": "2023-03-22T14:00:00Z",
      "href": "/api/things/5678/variables/1234",
      "id": "1234",
      "lastValue": "off",
      "name": "led_status",
      "permission": "read-write",
      "persist": true,
      "tag": "actuator",
      "thingId": "5678",
      "thingName": "led_controller",
      "type": "string",
      "updateStrategy": "on-change",
      "updatedAt": "2023-03-22T14:01:00Z",
      "valueUpdatedAt": "2023-03-22T14:01:00Z",
      "variableName": "led_status"
    },
    {
    "createdAt": "2023-03-22T12:30:00Z",
    "href": "/api/things/1234/variables/5679",
    "id": "5679",
    "lastValue": "true",
    "name": "heater_on",
    "permission": "read-write",
    "persist": true,
    "tag": "actuator",
    "thingId": "1234",
    "thingName": "thermostat",
    "type": "boolean",
    "updateStrategy": "on-change",
    "updatedAt": "2023-03-22T12:31:00Z",
    "valueUpdatedAt": "2023-03-22T12:31:00Z",
    "variableName": "heater_on"
  },
  {
    "createdAt": "2023-03-22T13:00:00Z",
    "href": "/api/things/1234/variables/5680",
    "id": "5680",
    "lastValue": "70",
    "name": "desired_temperature",
    "permission": "read-write",
    "persist": true,
    "tag": "setting",
    "thingId": "1234",
    "thingName": "thermostat",
    "type": "number",
    "updateStrategy": "on-change",
    "updatedAt": "2023-03-22T13:01:00Z",
    "valueUpdatedAt": "2023-03-22T13:01:00Z",
    "variableName": "desired_temperature"
  }
]''';


////////// code for sorting
  // onTap: () {
  //               print('tap works');
  //               // function goes here
  //               sortKeys() {
  //                 List<String> sortedKeys = jsonData.keys.toList();
  //                 sortedKeys.sort((a, b) => b.compareTo(a));

  //                 ListView.builder(
  //                   itemCount: jsonData.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     String key = sortedKeys[index];
  //                     // String key = sortedKeys[index];
  //                     dynamic value = jsonData[key];
  //                     return Card(
  //                       child: ListTile(
  //                         title: Text(key),
  //                         subtitle: Text(value.toString()),
  //                       ),
  //                     );
  //                   },
  //                 );
  //               }
  //             },