import 'package:flutter/material.dart';

import '../../events/event.dart';
import '../../style/theme.dart' as Theme;
import '../../utils/indexable.dart';
import '../views/event_details_page.dart';
import 'item_details.dart';

class EventDetails extends StatelessWidget implements Indexable {
  final Event event;
  final int index;
  final bool horizontal;
  static const String eventImage = "https://picsum.photos/300";

  const EventDetails({
    Key key,
    this.event,
    this.index,
    this.horizontal,
  }) : super(key: key);

  static EventDetails fromEvent(var event, var index) => EventDetails(
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

  Widget _buildHeader() => Text(
        event.name,
        style: ItemDetails.headerTextStyle,
        overflow: TextOverflow.ellipsis,
      );

  Widget _buildDescription() =>
      Text(event.getAddress(), style: ItemDetails.subHeaderTextStyle);

  List<TextWithIcon> _footer() => List.of([
        _getTextWithIcon(event.getDate(),
            Icon(Icons.calendar_today, color: _determineDateTimeColor())),
        _getTextWithIcon(event.getTime(),
            Icon(Icons.access_time, color: _determineDateTimeColor()))
      ]);

  _getTextWithIcon(String text, Icon icon) =>
      TextWithIcon(text: text, icon: icon);

  @override
  Widget build(BuildContext context) {
    return ItemDetails(
      item: event,
      horizontal: this.horizontal,
      index: this.index,
      imageUrl: EventDetails.eventImage,
      routingWidget: EventDetailsPage.fromRouting,
      heroDescription: "event",
      header: _buildHeader(),
      description: _buildDescription(),
      footerRowItems: _footer(),
    );
  }
}
