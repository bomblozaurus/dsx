import 'package:flutter/material.dart';

import '../../rooms/room.dart';
import '../../utils/indexable.dart';
import '../views/rooms_details_page.dart';
import 'item_details.dart';

class RoomDetails extends StatelessWidget implements Indexable {
  final Room room;
  final bool horizontal;
  final int index;
  static const String eventImage = "https://picsum.photos/300";

  const RoomDetails({Key key, this.room, this.horizontal, this.index})
      : super(key: key);

  static RoomDetails fromRoom(var event, var index) => RoomDetails(
        room: event,
        index: index,
        horizontal: true,
      );

  static RoomDetails vertical(Room room, int index) =>
      RoomDetails(room: room, horizontal: false, index: index);

  _buildHeader() {}

  _buildDescription() {}

  List<TextWithIcon> _footer() {
    return List.of([]);
  }

  @override
  Widget build(BuildContext context) {
    return ItemDetails(
        item: room,
        horizontal: horizontal,
        index: index,
        imageUrl: RoomDetails.eventImage,
        routingWidget: RoomDetailsPage.fromRouting,
        heroDescription: "room",
        header: _buildHeader(),
        description: _buildDescription(),
        footerRowItems: _footer());
  }
}
