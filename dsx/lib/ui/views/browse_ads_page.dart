import 'dart:async';

import 'package:dsx/models/ad.dart';
import 'package:dsx/models/user_details.dart';
import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:dsx/ui/widgets/ad_details.dart';
import 'package:dsx/ui/widgets/ad_form.dart';
import 'package:dsx/ui/widgets/lazy_loaded_list.dart';
import 'package:dsx/ui/widgets/search_app_bar.dart';
import 'package:dsx/utils/indexable.dart';
import 'package:dsx/utils/navigable.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

class BrowseAdsPage extends StatefulWidget implements Navigable, Indexable {
  @override
  _BrowseAdsPageState createState() => _BrowseAdsPageState();

  @override
  String getDescription() {
    return "ogłoszenia";
  }

  @override
  IconData getIconData() {
    return Icons.library_books;
  }
}

class _BrowseAdsPageState extends State<BrowseAdsPage> {
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

    void _showCreateAdForm() {
      showDialog(
          context: context,
          child: Theme(
            data: ThemeData(
                dialogBackgroundColor: DsxTheme.Colors.loginGradientEnd),
            child: SimpleDialog(
              children: <Widget>[
                Center(
                  child: Text(
                    "Dodaj ogłoszenie",
                    style: DsxTheme.TextStyles.headerTextStyle,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: AdForm(userDetails: _userDetails),
                ),
              ],
            ),
          ));
    }

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
                    serializer: Ad.fromJson,
                    creator: AdDetails.fromAd,
                    resourcePath: GlobalConfiguration().getString("adsUrl"),
                    pageSize: 10,
                  )),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
            child: FloatingActionButton(
                backgroundColor: DsxTheme.Colors.logoBackgroundColor,
                child: Icon(
                  Icons.add,
                  color: DsxTheme.Colors.loginGradientEnd,
                  size: 42.0,
                ),
                onPressed: _showCreateAdForm),
          ),
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
}
