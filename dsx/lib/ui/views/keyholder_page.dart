import 'dart:async';

import 'package:dsx/models/reservation.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/widgets/lazy_loaded_list.dart';
import 'package:dsx/ui/widgets/reservation_keyholder_details.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../widgets/search_app_bar.dart';

class KeyholderPage extends StatefulWidget {
  @override
  _KeyholderPageState createState() => _KeyholderPageState();
}

class _KeyholderPageState extends State<KeyholderPage> {
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
        decoration: BoxDecoration(
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
                itemCreator: ReservationKeyholderDetails.fromReservation,
                pageSize: 10,
                noDataMessage: "Twój pokój nie został jeszcze zarezerwowany",
                resourcePath:
                    GlobalConfiguration().getString("keyholderReservationsUrl"),
              ),
            ),
          ],
        ));
  }

  void _emitEndOfScroll() {
    _endOfScrollStreamController.sink.add(true);
  }
}
