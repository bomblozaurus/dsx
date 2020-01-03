import 'dart:convert';

import 'package:dsx/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class ShowEventsPage extends StatefulWidget {
  // This is a String for the sake of an example.
  // You can use any type you want.
  final String scope;
  final String dormitory = "1";

  ShowEventsPage({
    Key key,
    @required this.scope,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(scope, dormitory);
}

class _HomePageState extends State<ShowEventsPage> {
  final String scope;
  final String dormitory;

  _HomePageState(this.scope, this.dormitory);

  List<Event> _events = List<Event>();

  Future<List<Event>> fetchEvents() async {
    var queryParameters = {
      'scope': scope,
      'studentHouse': dormitory,
    };

    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("eventsUrl") +
        GlobalConfiguration().getString("eventOrderByDate") +
        "?scope=" +
        scope +
        "&studentHouse=" +
        dormitory;

    GlobalConfiguration().getString("eventsAll");

//    var url = 'https://raw.githubusercontent.com/boriszv/json/master/random_example.json';
    var response = await http.get(url);

    var events = List<Event>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        events.add(Event.fromJson(noteJson));
      }
    }
    return events;
  }

  @override
  void initState() {
    fetchEvents().then((value) {
      setState(() {
        _events.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("dlugosc tablicy");
    print(_events.length);
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter listview with json'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _events[index].name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _events[index].date.toString(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _events[index].description,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _events[index].street,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _events[index].houseNumber.toString(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _events[index].apartmentNumber.toString(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _events[index].city,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _events[index].zip,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _events[index].scope,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _events[index].studentHouse,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: _events.length,
        ));
  }
}
