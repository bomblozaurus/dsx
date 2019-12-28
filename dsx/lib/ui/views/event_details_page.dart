import 'package:dsx/utils/indexable.dart';
import 'package:flutter/material.dart';

import '../../events/event.dart';
import '../../style/theme.dart' as Theme;
import '../widgets/event_details.dart';

class EventDetailsPage extends StatefulWidget implements Indexable {
  final Event event;
  final CircleAvatar avatar;
  final int index;

  const EventDetailsPage({Key key, this.event, this.avatar, this.index})
      : super(key: key);

  static EventDetailsPage fromRouting(event, avatar, index) => EventDetailsPage(
        event: event,
        avatar: avatar,
        index: index,
      );

  @override
  _EventDetailsPageState createState() =>
      _EventDetailsPageState(this.event, this.avatar, this.index);
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final Event event;
  final CircleAvatar avatar;
  final int index;

  _EventDetailsPageState(this.event, this.avatar, this.index);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              Theme.Colors.loginGradientStart,
              Theme.Colors.loginGradientEnd
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
          ),
        ),
        constraints: new BoxConstraints.expand(),
        child: new Stack(
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
            _getToolbar(context),
          ],
        ),
      ),
    );
  }

  Container _getBackground() {
    return new Container(
      child: new Image.network(
        'https://picsum.photos/300',
        fit: BoxFit.cover,
        height: 260.0,
      ),
      constraints: new BoxConstraints.expand(height: 255.0),
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 205.0),
      height: 50.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            new Color.fromRGBO(
                Theme.Colors.loginGradientStart.red,
                Theme.Colors.loginGradientStart.green,
                Theme.Colors.loginGradientStart.blue,
                0.0),
            new Color.fromRGBO(
                Theme.Colors.loginGradientStart.red,
                Theme.Colors.loginGradientStart.green,
                Theme.Colors.loginGradientStart.blue,
                1.0)
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getContent() {
    return new Container(
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 78.0),
              child: EventDetails.vertical(event, index)),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(event.description,
                      style: TextStyle(color: Colors.white, fontSize: 24.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.white),
    );
  }
}
