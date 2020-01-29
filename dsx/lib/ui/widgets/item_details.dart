import 'package:dsx/utils/api_image.dart';
import 'package:dsx/utils/indexable.dart';
import 'package:dsx/utils/text_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../style/theme.dart' as Theme;
import '../../utils/fetchable.dart';
import 'material_hero.dart';

typedef Widget RoutingWidgetBuilder(var item, var avatar, var index);

abstract class ItemDetails<I extends Fetchable> extends StatelessWidget
    implements Indexable {
  final I item;
  final bool horizontal;
  final int index;
  final String heroDescription;

  const ItemDetails({
    Key key,
    @required this.horizontal,
    @required this.index,
    @required this.heroDescription,
    @required this.item,
  }) : super(key: key);

  List<TextWithIcon> getFooterItems();

  Widget buildHeader();

  Widget buildDescription();

  Widget buildRoutingWidget(I item, CircleAvatar avatar, int index);

  Widget getHeader(String text) {
    if (horizontal) {
      return text.length > 20 ? _getMarquee(text) : _getHeaderText(text);
    } else {
      return text.length > 22 ? _getMarquee(text) : _getHeaderText(text);
    }
  }

  Widget _getMarquee(String text) => Container(
        width: 350.0,
        height: 24.0,
        child: Marquee(
          text: text,
          style: Theme.TextStyles.headerTextStyle,
          scrollAxis: Axis.horizontal,
          blankSpace: 20.0,
          velocity: 100.0,
        ),
      );

  Widget _getHeaderText(String text) => Text(
        text,
        style: Theme.TextStyles.headerTextStyle,
      );

  getTextWithIcon(String text, Icon icon) =>
      TextWithIcon(text: text, icon: icon);

  @override
  Widget build(BuildContext context) {
    Widget alignAccordingly({Widget child}) {
      return Align(
          alignment: horizontal ? Alignment.centerLeft : Alignment.center,
          child: child);
    }

    Widget _buildIconWithDescription({String value, Icon icon}) {
      return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              horizontal ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: <Widget>[
            icon,
            Container(width: 4.0),
            Text(value),
          ]);
    }

    Widget _buildFooterItem(TextWithIcon data) {
      return Expanded(
          child: _buildIconWithDescription(value: data.text, icon: data.icon));
    }

    Iterable<Widget> _buildFooterItems() {
      return this
          .getFooterItems()
          .map((item) => _buildFooterItem(item))
          .toList();
    }

    Widget _buildItemInfo() {
      return Wrap(
        spacing: 0,
        children: <Widget>[
          MaterialHero(
              tag: "$heroDescription-header-${this.index}",
              child: DefaultTextStyle(
                  style: Theme.TextStyles.headerTextStyle,
                  child: alignAccordingly(child: buildHeader()))),
          Container(height: 10.0),
          MaterialHero(
              tag: "$heroDescription-description-${this.index}",
              child: DefaultTextStyle(
                  style: Theme.TextStyles.subHeaderTextStyle,
                  child: alignAccordingly(child: buildDescription()))),
          MaterialHero(
              tag: "$heroDescription-separator-${this.index}",
              child: alignAccordingly(
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      height: 3.0,
                      width: horizontal ? 24.0 : 64.0,
                      color: Theme.Colors.logoBackgroundColor))),
          MaterialHero(
              tag: "$heroDescription-row-${this.index}",
              child: DefaultTextStyle(
                style: Theme.TextStyles.regularTextStyle,
                child: alignAccordingly(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: _buildFooterItems(),
                )),
              )),
        ],
      );
    }

    CircleAvatar _fetchImage() {
      return CircleAvatar(
        child: ApiImage.getCircleAvatar(
            url: item.urls().elementAt(0), radius: 45.0),
        backgroundColor: Theme.Colors.logoBackgroundColor,
        radius: 50.0,
      );
    }

    Widget _buildItemInfoWithArrow() {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: _buildItemInfo()),
          Icon(Icons.arrow_forward_ios, color: Colors.white)
        ],
      );
    }

    _buildDescriptionBody() {
      return horizontal ? _buildItemInfoWithArrow() : _buildItemInfo();
    }

    final CircleAvatar avatar = _fetchImage();

    Widget buildItemDescription() {
      return Container(
        margin: EdgeInsets.fromLTRB(
            horizontal ? 112.0 : 8.0, horizontal ? 8.0 : 112.0, 8.0, 8.0),
        constraints: BoxConstraints.expand(),
        child: _buildDescriptionBody(),
      );
    }

    return InkWell(
        onTap: horizontal
            ? () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    buildRoutingWidget(item, avatar, index),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;

                  var curve = Curves.easeInQuad;
                  var curveTween = CurveTween(curve: curve);

                  var tween = Tween(begin: begin, end: end).chain(curveTween);

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                }))
            : null,
        child: Container(
          height: horizontal ? 125.0 : 240.0,
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: Stack(
            children: <Widget>[
              Stack(children: <Widget>[
                Hero(
                    tag: "$heroDescription-background-container-${this.index}",
                    child: Container(
                      height: horizontal ? 124.0 : 186.0,
                      margin: horizontal
                          ? EdgeInsets.only(left: 46.0)
                          : EdgeInsets.only(top: 46.0),
                      decoration: BoxDecoration(
                        color: Theme.Colors.loginGradientEnd,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                    )),
                buildItemDescription(),
              ]),
              Container(
                  alignment: horizontal
                      ? FractionalOffset.centerLeft
                      : FractionalOffset.topCenter,
                  child: Hero(
                      tag: "$heroDescription-avatar-${this.index}",
                      child: avatar)),
            ],
          ),
        ));
  }
}
