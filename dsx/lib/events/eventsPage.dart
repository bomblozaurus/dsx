import 'dart:collection';
import 'dart:convert';

import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:global_configuration/global_configuration.dart';

import '../ui/navigable.dart';
import '../utils/requests.dart';
import 'event.dart';

class BrowseEventsPage extends StatefulWidget implements Navigable {
  @override
  _BrowseEventsPageState createState() => _BrowseEventsPageState();

  @override
  String getDescription() {
    return "Wydarzenia";
  }

  @override
  IconData getIconData() {
    return Icons.event;
  }
}

class _BrowseEventsPageState extends State<BrowseEventsPage> {
  var _events = new LinkedHashSet.of([]);
  ScrollController _scrollController = ScrollController();

  bool isFetching;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              Theme.Colors.loginGradientStart,
              Theme.Colors.loginGradientEnd
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Stack(
        children: <Widget>[
          Center(child: _determineIfFetching()),
          ListView.builder(
              controller: _scrollController,
              itemCount: _events.length,
              itemBuilder: (BuildContext context, int index) {
                return EventHeader(event: _events.elementAt(index));
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchEvents();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _fetchEvents() async {
    setState(() {
      this.isFetching = true;
    });
    final int pageSize = 10;
    String events = GlobalConfiguration().getString("eventsUrl");
    int pageNo = (_events.length / pageSize).ceil();
    String pageOfEventsUrl = '$events?size=$pageSize&page=$pageNo';

    List newEvents = List();
    await Request()
        .getToMobileApi(resourcePath: pageOfEventsUrl)
        .then((response) {
      var body = json.decode(response.body);
      newEvents = (body['_embedded']['events'] as List)
          .map((event) => Event.fromJson(event))
          .toList();
    });

    print(newEvents);

    setState(() {
      this._events.addAll(newEvents);
      this.isFetching = false;
    });
  }

  _determineIfFetching() {
    if (this.isFetching) {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue), strokeWidth: 5.0);
    }
  }
}

class EventHeader extends StatelessWidget {
  final Event event;

  EventHeader({this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: null,
        child: Card(
          color: Color.fromRGBO(
              Theme.Colors.loginGradientStart.red,
              Theme.Colors.loginGradientStart.green,
              Theme.Colors.loginGradientStart.blue,
              0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 130,
                  height: 130,
                  color: Colors.red,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        this.event.name,
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        this.event.date.toLocal().toString(),
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
