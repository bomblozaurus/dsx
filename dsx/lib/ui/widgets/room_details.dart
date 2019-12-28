import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

import '../../rooms/room.dart';
import '../../utils/indexable.dart';
import '../../utils/time.dart';
import '../views/rooms_details_page.dart';
import 'item_details.dart';

class RoomDetails extends ItemDetails<Room> implements Indexable {
  final Room room;
  final bool horizontal;
  final int index;

  const RoomDetails({Key key, this.room, this.horizontal, this.index})
      : super(
            key: key,
            item: room,
            horizontal: horizontal,
            index: index,
            heroDescription: "room");

  static RoomDetails fromRoom(var event, var index) =>
      RoomDetails(
        room: event,
        index: index,
        horizontal: true,
      );

  static RoomDetails vertical(Room room, int index) =>
      RoomDetails(room: room, horizontal: false, index: index);

  @override
  Widget buildHeader() =>
      Text(
        room.name,
        style: ItemDetails.headerTextStyle,
        overflow: TextOverflow.ellipsis,
      );

  @override
  Widget buildDescription() =>
      Text('DS ${room.dsNumber}', style: ItemDetails.subHeaderTextStyle);

  @override
  Widget buildRoutingWidget(Room item, CircleAvatar avatar, int index) =>
      RoomDetailsPage.fromRouting(item, avatar, index);

  _determineOpenHourColor() {
    var now = Time(TimeOfDay.now());
    return (now >= room.openFrom && now <= room.openFrom)
        ? Theme.Colors.logoBackgroundColor
        : Colors.red;
  }

  _determineDurationColor() {
    return Colors.white;
  }

  @override
  List<TextWithIcon> getFooterItems() {
    return List.of([
      getTextWithIcon("${room.openFrom.toString()}-${room.openTo.toString()} ",
          Icon(Icons.access_time, color: _determineOpenHourColor())),
      getTextWithIcon(room.rentInterval.toString(),
          Icon(Icons.timelapse, color: _determineDurationColor()))
    ]);
  }
}
