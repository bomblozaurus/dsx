import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../events/event.dart';
import '../../utils/navigable.dart';
import '../widgets/lazy_loaded_list.dart';

class BrowseEventsPage extends StatefulWidget implements Navigable {
  @override
  _BrowseEventsPageState createState() => _BrowseEventsPageState();

  @override
  String getDescription() {
    return "Wydarzenia";
  }

  @override
  IconData getIconData() {
    return Icons.event;
  }
}

class _BrowseEventsPageState extends State<BrowseEventsPage> {
  static final String eventsUrl = GlobalConfiguration().getString("eventsUrl");

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Theme.Colors.loginGradientStart,
                Theme.Colors.loginGradientEnd
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: LazyLoadedList(
          keyList: ['_embedded', 'events'],
          serializer: Event.staticFromJson,
          itemBuilder: _buildItem,
          pageSize: 10,
          resourcePath: eventsUrl,
        ));
  }

  Widget _buildItem(dynamic event) {
    return InkWell(
      onTap: null,
      child: Card(
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          color: Color.fromRGBO(
              Theme.Colors.loginGradientStart.red,
              Theme.Colors.loginGradientStart.green,
              Theme.Colors.loginGradientStart.blue,
              0.1),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.white24))),
                child: _fetchImage(),
              ),
              title: Text(
                event.name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today,
                        color: (event.date
                                    .difference(DateTime.now())
                                    .inMilliseconds >
                                0)
                            ? Theme.Colors.logoBackgroundColor
                            : Colors.red),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                      child: Text(event.getDateTime(),
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0))),
    );
  }

  Widget _fetchImage() => CircleAvatar(
      backgroundColor:
          Colors.redAccent); //TODO ZAIMPLEMENTOWAĆ ZACIĄGANIE ZDJĘĆ + API

}
