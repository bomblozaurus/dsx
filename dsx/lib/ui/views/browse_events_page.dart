import 'dart:async';

import 'package:dsx/models/user_details.dart';
import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:dsx/ui/widgets/event_details.dart';
import 'package:dsx/ui/widgets/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

import '../../models/event.dart';
import '../../utils/navigable.dart';
import '../widgets/lazy_loaded_list.dart';

class BrowseEventsPage extends StatefulWidget implements Navigable {
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
  _BrowseEventsPageState createState() => _BrowseEventsPageState();
}

class _BrowseEventsPageState extends State<BrowseEventsPage> {
  StreamController<String> _queryStreamController = StreamController<String>();
  StreamController<bool> _endOfScrollStreamController =
      StreamController<bool>();
  ScrollController _scrollController;

  _search(String query) {
    this._queryStreamController.sink.add(query);
  }

  void _emitEndOfScroll() {
    _endOfScrollStreamController.sink.add(true);
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails _userDetails = Provider.of<UserDetails>(context);

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(gradient: DsxTheme.Colors.primaryGradient),
        ),
        CustomScrollView(
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
                  serializer: Event.fromJson,
                  itemCreator: EventDetails.fromEvent,
                  resourcePath: GlobalConfiguration().getString("eventsUrl"),
                  pageSize: 10,
                  noDataMessage: "Brak dostępnych wydarzeń",
                ),
              ),
            ),
          ],
        ),
      ],
    );
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
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _queryStreamController.close();
    _endOfScrollStreamController.close();
  }

//  @override
//  Widget build(BuildContext context) {
//    return Container(
//        width: MediaQuery.of(context).size.width,
//        decoration: BoxDecoration(
//          gradient: Theme.Colors.primaryGradient,
//        ),
//        child: LazyLoadedList(
//          keyList: ["content"],
//          serializer: Event.fromJson,
//          creator: EventDetails.fromEvent,
//          pageSize: 10,
//          resourcePath: BrowseEventsPage.eventsUrl,
//          noDataMessage: "Brak dostępnych wydarzeń",
//        ));
//  }
}
