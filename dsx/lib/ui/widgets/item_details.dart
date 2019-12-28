import 'package:dsx/utils/indexable.dart';
import 'package:flutter/material.dart';

import '../../style/theme.dart' as Theme;

typedef Widget RoutingWidgetBuilder(var a, var b, var c);

class ItemDetails<I> extends StatelessWidget implements Indexable {
  final I item;
  final bool horizontal;
  final int index;
  final String imageUrl;
  final RoutingWidgetBuilder routingWidget;
  final String heroDescription;
  final header;
  final description;
  final List<TextWithIcon> footerRowItems;

  const ItemDetails({
    Key key,
    @required this.item,
    @required this.horizontal,
    @required this.index,
    @required this.imageUrl,
    @required this.routingWidget,
    @required this.heroDescription,
    @required this.header,
    @required this.description,
    this.footerRowItems,
  }) : super(key: key);

  static var baseTextStyle = const TextStyle(fontFamily: 'Poppins');
  static var regularTextStyle = baseTextStyle.copyWith(
      color: const Color(0xffb6b2df),
      fontSize: 9.0,
      fontWeight: FontWeight.w400);
  static var subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 14.0);
  static var headerTextStyle = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    Widget alignAccordingly({Widget child}) {
      return Align(
          alignment: horizontal ? Alignment.centerLeft : Alignment.center,
          child: child);
    }

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

    Widget _buildFooterItem(TextWithIcon data) {
      return Expanded(
          child: _buildIconWithDescription(value: data.text, icon: data.icon));
    }

    Iterable<Widget> _buildFooterItems() {
      return this.footerRowItems.map((item) => _buildFooterItem(item)).toList();
    }

    Widget _buildItemInfo() {
      return Wrap(
        spacing: 0,
        children: <Widget>[
          Hero(
              tag: "$heroDescription-header-${this.index}",
              child: alignAccordingly(child: this.header)),
          new Container(height: 10.0),
          Hero(
              tag: "$heroDescription-description-${this.index}",
              child: alignAccordingly(child: this.description)),
          Hero(
              tag: "$heroDescription-separator-${this.index}",
              child: alignAccordingly(
                  child: Container(
                      margin: new EdgeInsets.symmetric(vertical: 8.0),
                      height: 3.0,
                      width: horizontal ? 24.0 : 64.0,
                      color: Theme.Colors.logoBackgroundColor))),
          Hero(
              tag: "$heroDescription-row-${this.index}",
              child: alignAccordingly(
                  child: Row(
                mainAxisSize: MainAxisSize.max,
                children: _buildFooterItems(),
              ))),
        ],
      );
    }

    CircleAvatar _fetchImage() {
      return CircleAvatar(
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 45.0,
        ),
        backgroundColor: Theme.Colors.logoBackgroundColor,
        radius: 50.0,
      );
    }

    Widget _buildEventInfoWithArrow() {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: _buildItemInfo()),
          Icon(Icons.arrow_forward_ios, color: Colors.white)
        ],
      );
    }

    _buildDescriptionBody() {
      return horizontal ? _buildEventInfoWithArrow() : _buildItemInfo();
    }

    final CircleAvatar avatar = _fetchImage();

    Widget buildEventDescription() {
      return Container(
        margin: new EdgeInsets.fromLTRB(
            horizontal ? 112.0 : 12.0, horizontal ? 12.0 : 112.0, 12.0, 12.0),
        constraints: new BoxConstraints.expand(),
        child: _buildDescriptionBody(),
      );
    }

    return InkWell(
        onTap: horizontal
            ? () => Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    routingWidget(item, avatar, index)))
            : null,
        child: Container(
          height: horizontal ? 125.0 : 240.0,
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: new Stack(
            children: <Widget>[
              Stack(children: <Widget>[
                Hero(
                    tag: "$heroDescription-background-container-${this.index}",
                    child: Container(
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
                    )),
                buildEventDescription(),
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

class TextWithIcon {
  final String text;
  final Icon icon;

  TextWithIcon({this.text, this.icon});
}
