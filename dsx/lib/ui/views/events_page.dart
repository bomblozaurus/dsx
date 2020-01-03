import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/widgets/event_details.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../models/event.dart';
import '../../utils/navigable.dart';
import '../widgets/lazy_loaded_list.dart';

class BrowseEventsPage extends StatelessWidget implements Navigable {
  static final String eventsUrl = GlobalConfiguration().getString("eventsUrl");

  @override
  String getDescription() {
    return "Wydarzenia";
  }

  @override
  IconData getIconData() {
    return Icons.event;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          gradient: Theme.Colors.primaryGradient,
        ),
        child: LazyLoadedList(
          keyList: ["content"],
          serializer: Event.fromJson,
          creator: EventDetails.fromEvent,
          pageSize: 10,
          resourcePath: eventsUrl,
        ));
  }
}
