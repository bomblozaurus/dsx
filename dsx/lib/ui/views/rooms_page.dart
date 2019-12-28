import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

import '../../rooms/room.dart';
import '../../utils/indexable.dart';
import '../../utils/navigable.dart';
import '../widgets/lazy_loaded_list.dart';
import '../widgets/room_details.dart';

class BrowseRoomsPage extends StatelessWidget implements Navigable, Indexable {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: Theme.Colors.primaryGradient),
        child: LazyLoadedList(
          keyList: [],
          serializer: Room.fromJson,
          creator: RoomDetails.fromRoom,
          resourcePath: "/rooms",
          pageSize: 10,
        ));
  }

  @override
  String getDescription() {
    return "pokoje";
  }

  @override
  IconData getIconData() {
    return Icons.vpn_key;
  }
}
