import 'dart:async';

import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/views/reservation_page.dart';
import 'package:dsx/ui/widgets/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../models/room.dart';
import '../../utils/indexable.dart';
import '../../utils/navigable.dart';
import '../widgets/lazy_loaded_list.dart';
import '../widgets/room_details.dart';

class BrowseRoomsPage extends StatefulWidget implements Navigable, Indexable {
  String getDescription() {
    return "pokoje";
  }

  @override
  IconData getIconData() {
    return Icons.vpn_key;
  }

  @override
  _BrowseRoomsPageState createState() => _BrowseRoomsPageState();
}

class _BrowseRoomsPageState extends State<BrowseRoomsPage> {
  StreamController<String> _queryStreamController = StreamController<String>();

  _search(String query) {
    this._queryStreamController.sink.add(query);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(gradient: Theme.Colors.primaryGradient),
        ),
        DefaultTabController(
          length: 2,
          child: TabBarView(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SearchAppBar(
                    search: _search,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: LazyLoadedList(
                          queryStream: _queryStreamController.stream,
                          keyList: ['content'],
                          serializer: Room.fromJson,
                          creator: RoomDetails.fromRoom,
                          resourcePath:
                              GlobalConfiguration().getString("roomsUrl"),
                          pageSize: 10,
                        )),
                  ),
                ],
              ),
              ReservationPage(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _queryStreamController.close();
  }
}
