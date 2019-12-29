import 'package:flutter/material.dart';

typedef Widget SliverBuilder(BuildContext context);

class SliverContent extends StatefulWidget {
  final String title;
  final Widget appBarBackground;
  final List<SliverBuilder> sliverBuilders;
  final appBarHeight;

  const SliverContent(
      {Key key,
      this.title,
      this.appBarBackground,
      this.appBarHeight,
      this.sliverBuilders})
      : super(key: key);

  @override
  factory SliverContent.standard(
          {String title,
          Widget appBarBackground,
          List<Function> sliverBuilders}) =>
      SliverContent(
        title: title,
        appBarBackground: appBarBackground,
        appBarHeight: 330.0,
        sliverBuilders: sliverBuilders,
      );

  _SliverContentState createState() => _SliverContentState(
      title, sliverBuilders, appBarBackground, appBarHeight);
}

class _SliverContentState extends State<SliverContent> {
  final String title;
  final List<Function> sliverBuilders;
  final Widget appBarBackground;
  final double appBarHeight;

  double visiblePartOfAppBar = 1.0;
  Color appBarColor = Colors.transparent;
  Color titleColor = Colors.transparent;

  ScrollController _scrollController;

  _SliverContentState(this.title, this.sliverBuilders, this.appBarBackground,
      this.appBarHeight);

  @override
  void initState() {
    super.initState();

    sliverBuilders.insert(0, _getSliverAppBar());

    _scrollController = ScrollController()
      ..addListener(() {
        double newPart = _getVisiblePartOfAppBar();
        if (visiblePartOfAppBar != newPart) {
          setState(() {
            visiblePartOfAppBar = newPart;
            appBarColor = Color.fromRGBO(00, 00, 00, 1.0 - visiblePartOfAppBar);
            titleColor =
                Color.fromRGBO(255, 255, 255, 1.0 - visiblePartOfAppBar);
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        controller: _scrollController, slivers: _getSlivers());
  }

  List<Widget> _getSlivers() => sliverBuilders
      .map((builder) => (Function.apply(builder, [context]) as Widget))
      .toList();

  double _getVisiblePartOfAppBar() {
    var offset = _scrollController.offset;
    double toReturn =
        (offset < appBarHeight) ? 1.0 - (offset / appBarHeight) : 0.0;
    return toReturn;
  }

  Function _getSliverAppBar() => (context) => SliverAppBar(
        title: Text(title, style: TextStyle(color: titleColor)),
        backgroundColor: appBarColor,
        floating: true,
        pinned: true,
        centerTitle: true,
        expandedHeight: appBarHeight,
        flexibleSpace: FlexibleSpaceBar(background: appBarBackground),
      );
}
