import 'package:dsx/utils/api_image.dart';
import 'package:dsx/utils/indexable.dart';
import 'package:flutter/material.dart';

import '../../style/theme.dart' as Theme;
import '../../utils/fetchable.dart';

abstract class DetailsPage<I extends Fetchable> extends StatelessWidget
    implements Indexable {
  final I item;
  final CircleAvatar avatar;
  final int index;

  const DetailsPage({
    Key key,
    this.avatar,
    this.index,
    this.item,
  }) : super(key: key);

  Widget getContent();

  Widget getHeader() {
    return Stack(
      children: <Widget>[_getGradient(), _getBackground()],
    );
  }

  Container _getBackground() {
    return Container(
      child:
          ApiImage.getImage(url: item.urls().elementAt(0), fit: BoxFit.cover),
      constraints: new BoxConstraints.expand(height: 265.0),
    );
  }

  Container _getGradient() {
    return Container(
      margin: EdgeInsets.only(top: 105.0),
      height: 160.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(
                Theme.Colors.loginGradientStart.red,
                Theme.Colors.loginGradientStart.green,
                Theme.Colors.loginGradientStart.blue,
                0.0),
            Color.fromRGBO(
                Theme.Colors.loginGradientStart.red,
                Theme.Colors.loginGradientStart.green,
                Theme.Colors.loginGradientStart.blue,
                0.8)
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          gradient: Theme.Colors.primaryGradient,
        ),
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: <Widget>[
            getContent(),
          ],
        ),
      )),
    );
  }
}
