import 'dart:async';

import 'package:dsx/models/user_details.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/views/keyholder_page.dart';
import 'package:dsx/ui/views/reservation_page.dart';
import 'package:dsx/ui/widgets/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

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
  StreamController<bool> _endOfScrollStreamController =
      StreamController<bool>();
  ScrollController _scrollController;
  int tabsCount, initialIndex;

  _search(String query) {
    this._queryStreamController.sink.add(query);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _emitEndOfScroll();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails _userDetails = Provider.of<UserDetails>(context);
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(gradient: Theme.Colors.primaryGradient),
        ),
        DefaultTabController(
          child: TabBarView(
            children: _getTabViewChildren(context, _userDetails),
          ),
          length: tabsCount,
          initialIndex: initialIndex,
        ),
      ],
    );
  }

  List<Widget> _getTabViewChildren(
      BuildContext context, UserDetails _userDetails) {
    List<Widget> children = List<Widget>();
    if (_userDetails?.isKeyholder() ?? false) {
      children.add(KeyholderPage());
    }

    children..add(_buildRoomsList(context))..add(ReservationPage());

    setState(() {
      tabsCount = children.length;
      initialIndex = children.length == 3 ? 1 : 0;
    });

    return children;
  }

  CustomScrollView _buildRoomsList(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SearchAppBar(
          search: _search,
        ),
        SliverToBoxAdapter(
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: LazyLoadedList(
                fetchingStream: _endOfScrollStreamController.stream,
                queryStream: _queryStreamController.stream,
                keyList: ['content'],
                serializer: Room.fromJson,
                creator: RoomDetails.fromRoom,
                resourcePath: GlobalConfiguration().getString("roomsUrl"),
                pageSize: 10,
              )),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _queryStreamController.close();
    _endOfScrollStreamController.close();
  }

  void _emitEndOfScroll() {
    _endOfScrollStreamController.sink.add(true);
  }
}
