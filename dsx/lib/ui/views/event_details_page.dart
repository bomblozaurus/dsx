import 'package:dsx/utils/indexable.dart';
import 'package:flutter/material.dart';

import '../../events/event.dart';
import '../widgets/event_details.dart';
import '../widgets/sliver_content.dart';
import 'details_page.dart';

class EventDetailsPage extends DetailsPage implements Indexable {
  final Event event;
  final CircleAvatar avatar;
  final int index;

  const EventDetailsPage({Key key, this.event, this.avatar, this.index})
      : super(
          key: key,
          item: event,
          avatar: avatar,
          index: index,
        );

  static EventDetailsPage fromRouting(event, avatar, index) => EventDetailsPage(
        event: event,
        avatar: avatar,
        index: index,
      );

  @override
  Widget getContent() {
    return Column(children: <Widget>[
      Expanded(
        child: SliverContent.standard(
            title: event.name,
            appBarBackground: Stack(children: <Widget>[
              getHeader(),
              Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: EventDetails.vertical(event, index)),
            ]),
            sliverBuilders: []),
      ), //      Container(height: 400.0, color: Colors.red)
    ]);
  }
}
