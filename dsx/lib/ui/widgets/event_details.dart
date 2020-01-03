import 'package:dsx/utils/text_with_icon.dart';
import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../style/theme.dart' as Theme;
import '../../utils/fetchable.dart';
import '../../utils/indexable.dart';
import '../views/event_details_page.dart';
import 'item_details.dart';

class EventDetails extends ItemDetails<Event> implements Indexable {
  final Event event;
  final int index;
  final bool horizontal;

  const EventDetails({
    Key key,
    this.event,
    this.index,
    this.horizontal,
  }) : super(
            key: key,
            item: event,
            index: index,
            horizontal: horizontal,
            heroDescription: "item");

  static EventDetails fromEvent(var event, var index) =>
      EventDetails(
        event: event,
        index: index,
        horizontal: true,
      );

  static EventDetails vertical(Event event, int index) =>
      EventDetails(event: event, horizontal: false, index: index);

  Color _determineDateTimeColor() {
    return (event.date.difference(DateTime.now()).inMilliseconds > 0)
        ? Theme.Colors.logoBackgroundColor
        : Colors.red;
  }

  @override
  Widget buildDescription() =>
      Text(event.getAddress(),);

  @override
  Widget buildHeader() =>
      Text(
        event.name,
        overflow: TextOverflow.ellipsis,
      );

  @override
  Widget buildRoutingWidget(Fetchable item, CircleAvatar avatar, int index) =>
      EventDetailsPage.fromRouting(item, avatar, index);

  @override
  List<TextWithIcon> getFooterItems() =>
      List.of([
        getTextWithIcon(event.getDate(),
            Icon(Icons.calendar_today, color: _determineDateTimeColor())),
        getTextWithIcon(event.getTime(),
            Icon(Icons.access_time, color: _determineDateTimeColor()))
      ]);
}
