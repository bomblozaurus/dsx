import 'dart:async';

import 'package:dsx/models/reservation.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/widgets/lazy_loaded_list.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../widgets/reservation_details.dart';
import '../widgets/search_app_bar.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  _search(String query) {
    this._queryStreamController.sink.add(query);
  }

  StreamController<String> _queryStreamController = StreamController<String>();
  StreamController<bool> _endOfScrollStreamController =
      StreamController<bool>();
  ScrollController _scrollController;

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
    _queryStreamController.close();
    _endOfScrollStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          gradient: Theme.Colors.primaryGradient,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SearchAppBar(
              search: _search,
            ),
            SliverToBoxAdapter(
              child: LazyLoadedList(
                fetchingStream: _endOfScrollStreamController.stream,
                queryStream: _queryStreamController.stream,
                keyList: ["content"],
                serializer: Reservation.fromJson,
                creator: ReservationDetails.fromReservation,
                pageSize: 10,
                resourcePath:
                GlobalConfiguration().getString("reservationsUrl"),
              ),
            ),
          ],
        ));
  }

  void _emitEndOfScroll() {
    _endOfScrollStreamController.sink.add(true);
  }
}
