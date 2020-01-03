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

  @override
  void dispose() {
    super.dispose();
    _queryStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          gradient: Theme.Colors.primaryGradient,
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SearchAppBar(
              search: _search,
            ),
            SliverToBoxAdapter(
              child: LazyLoadedList(
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
}
