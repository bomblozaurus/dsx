import 'package:dsx/utils/indexable.dart';
import 'package:flutter/material.dart';

import '../../events/event.dart';
import '../../style/theme.dart' as Theme;
import '../../utils/navigable.dart';
import '../views/event_details_page.dart';

class EventDetails extends StatefulWidget implements Indexable, Navigable {
  final Event event;
  final bool horizontal;
  final int index;

  const EventDetails({Key key, this.event, this.horizontal, this.index})
      : super(key: key);

  static EventDetails fromEvent(var event, var index) => EventDetails(
        event: event,
        index: index,
        horizontal: true,
      );

  static EventDetails vertical(Event event, int index) =>
      EventDetails(event: event, horizontal: false, index: index);

  @override
  _EventDetailsState createState() =>
      _EventDetailsState(this.event, horizontal, index);

  @override
  String getDescription() {
    return "SZCZEGÓŁY";
  }

  @override
  IconData getIconData() {
    return Icons.details;
  }
}

class _EventDetailsState extends State<EventDetails> {
  final Event event;
  final bool horizontal;
  final int index;

  _EventDetailsState(this.event, this.horizontal, this.index);

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400);
    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 14.0);
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600);

    Widget _buildIconWithDescription({String value, Icon icon}) {
      return new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              horizontal ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: <Widget>[
            icon,
            new Container(width: 8.0),
            new Text(value, style: regularTextStyle),
          ]);
    }

    Color _determineDateTimeColor() {
      return (event.date.difference(DateTime.now()).inMilliseconds > 0)
          ? Theme.Colors.logoBackgroundColor
          : Colors.red;
    }

    Widget _alignAccordingly({Widget child}) {
      return Align(
          alignment: horizontal ? Alignment.centerLeft : Alignment.center,
          child: child);
    }

    Widget _buildEventInfo() {
      return Wrap(
        spacing: 0,
        children: <Widget>[
          _alignAccordingly(
              child: Text(
            event.name,
            style: headerTextStyle,
            overflow: TextOverflow.ellipsis,
          )),
          new Container(height: 10.0),
          _alignAccordingly(
              child: Text(event.getAddress(), style: subHeaderTextStyle)),
          _alignAccordingly(
              child: Container(
                  margin: new EdgeInsets.symmetric(vertical: 8.0),
                  height: 3.0,
                  width: horizontal ? 24.0 : 64.0,
                  color: Theme.Colors.logoBackgroundColor)),
          new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                  child: _buildIconWithDescription(
                      value: event.getDate(),
                      icon: Icon(Icons.calendar_today,
                          color: _determineDateTimeColor()))),
              new Expanded(
                  child: _buildIconWithDescription(
                      value: event.getTime(),
                      icon: Icon(Icons.access_time,
                          color: _determineDateTimeColor())))
            ],
          ),
        ],
      );
    }

    Widget _buildEventInfoWithArrow() {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: _buildEventInfo()),
          Icon(Icons.arrow_forward_ios, color: Colors.white)
        ],
      );
    }

    _buildDescriptionBody() {
      return horizontal ? _buildEventInfoWithArrow() : _buildEventInfo();
    }

    CircleAvatar _fetchImage() {
      return CircleAvatar(
        child: CircleAvatar(
          backgroundImage: NetworkImage('https://picsum.photos/300'),
          radius: 45.0,
        ),
        backgroundColor: Theme.Colors.logoBackgroundColor,
        radius: 50.0,
      );
    } //TODO ZAIMPLEMENTOWAĆ ZACIĄGANIE ZDJĘĆ + API

    final CircleAvatar avatar = _fetchImage();

    Widget _buildEventDescription() {
      return Container(
        margin: new EdgeInsets.fromLTRB(
            horizontal ? 72.0 : 12.0, horizontal ? 12.0 : 72.0, 12.0, 12.0),
        constraints: new BoxConstraints.expand(),
        child: _buildDescriptionBody(),
      );
    }

    return InkWell(
        onTap: horizontal
            ? () => Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_, __, ___) => EventDetailsPage(
                      event: event,
                      avatar: avatar,
                      index: index,
                    )))
            : null,
        child: Hero(
          tag: "event-${this.index}",
          child: new Container(
              height: horizontal ? 125.0 : 240.0,
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: new Stack(
                children: <Widget>[
                  Container(
                    child: _buildEventDescription(),
                    height: horizontal ? 124.0 : 186.0,
                    margin: horizontal
                        ? new EdgeInsets.only(left: 46.0)
                        : new EdgeInsets.only(top: 46.0),
                    decoration: new BoxDecoration(
                      color: Theme.Colors.loginGradientEnd,
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: new Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      alignment: horizontal
                          ? FractionalOffset.centerLeft
                          : FractionalOffset.topCenter,
                      child: avatar),
                ],
              )),
        ));
  }
}
