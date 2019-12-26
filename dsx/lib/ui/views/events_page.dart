import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/widgets/event_details.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../events/event.dart';
import '../../utils/navigable.dart';
import '../widgets/lazy_loaded_list.dart';

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
  static final String eventsUrl = GlobalConfiguration().getString("eventsUrl");

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
        child: LazyLoadedList(
          keyList: ['_embedded', 'events'],
          serializer: Event.staticFromJson,
          creator: EventDetails.fromEvent,
          pageSize: 10,
          resourcePath: eventsUrl,
        ));
  }
}
