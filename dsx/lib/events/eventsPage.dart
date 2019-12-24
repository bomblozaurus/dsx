import 'package:dsx/events/event.dart';
import 'package:dsx/utils/requests.dart' as ApiRequest;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';

import '../ui/navigable.dart';

class BrowsEventsPage extends StatefulWidget implements Navigable {
  @override
  _BrowsEventsPageState createState() => _BrowsEventsPageState();

  @override
  String getDescription() {
    return "Wydarzenia";
  }

  @override
  IconData getIconData() {
    return Icons.event;
  }
}

class _BrowsEventsPageState extends State<BrowsEventsPage> {
  var _events;

  @override
  Widget build(BuildContext context) {
    _events = _fetchEvents();
    return SingleChildScrollView(
      child: Expanded(child: Column()),
    );
  }

  Future<List<Event>> _fetchEvents() async {
    final String eventsPath = GlobalConfiguration().getString("eventsUrl") +
        GlobalConfiguration().getString("eventsAll");
    Response r;
    await ApiRequest.Request()
        .getToMobileApi(resourcePath: eventsPath)
        .then((response) => r = response);
    return [];
  }
}
