import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

import '../../rooms/room.dart';
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
  TextEditingController _searchInputController;
  String _query;

  @override
  void initState() {
    _searchInputController = TextEditingController();
  }

  _search() {
    setState(() {
      this._query = _searchInputController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _detailsColor = Theme.Colors.loginGradientEnd;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Theme.Colors.logoBackgroundColor,
          primary: true,
          pinned: false,
          floating: true,
          centerTitle: true,
          snap: true,
          title:
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 40.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
                color: Color.fromRGBO(_detailsColor.red, _detailsColor.green,
                    _detailsColor.blue, 0.3)),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 8.0),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: _search(),
                        cursorColor: _detailsColor,
                        controller: _searchInputController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          helperStyle: TextStyle(
                            color: Theme.Colors.loginGradientEnd,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.Colors.loginGradientEnd,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () => _search(),
                    child: Icon(Icons.search,
                        color: Theme.Colors.loginGradientEnd, size: 32.0),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(gradient: Theme.Colors.primaryGradient),
              child: LazyLoadedList(
                query: this._query,
                keyList: ['content'],
                serializer: Room.fromJson,
                creator: RoomDetails.fromRoom,
                resourcePath: "/rooms/available",
                pageSize: 10,
              )),
        ),
      ],
    );
  }
}
