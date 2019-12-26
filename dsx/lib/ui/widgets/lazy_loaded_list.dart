import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../utils/requests.dart';

typedef Widget ItemBuilderFunction(T);

class LazyLoadedList<T> extends StatefulWidget {
  final int pageSize;
  final String resourcePath;
  final Function serializer;
  final ItemBuilderFunction itemBuilder;
  final List<String> keyList;

  const LazyLoadedList(
      {@required this.pageSize,
      @required this.resourcePath,
      @required this.serializer,
      @required this.itemBuilder,
      @required this.keyList});

  @override
  _LazyLoadedListState createState() => _LazyLoadedListState<T>(
      pageSize: this.pageSize,
      resourcePath: this.resourcePath,
      serializer: this.serializer,
      keyList: this.keyList,
      itemBuilder: this.itemBuilder);
}

class _LazyLoadedListState<T> extends State<LazyLoadedList> {
  HashSet<T> _items;
  ScrollController _scrollController = ScrollController();
  bool isFetching;

  final int pageSize;
  final String resourcePath;
  final Function serializer;
  final ItemBuilderFunction itemBuilder;
  final List<String> keyList;

  _LazyLoadedListState(
      {@required this.pageSize,
      @required this.resourcePath,
      @required this.serializer,
      @required this.keyList,
      @required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(child: _determineIfFetching()),
        ListView.builder(
            controller: _scrollController,
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              return itemBuilder(_items.elementAt(index));
            })
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchEvents();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _determineIfFetching() {
    if (this.isFetching) {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue), strokeWidth: 5.0);
    }
  }

  _fetchEvents() async {
    setState(() {
      this.isFetching = true;
    });
    String events = GlobalConfiguration().getString("eventsUrl");
    int pageNo = (_items.length / this.pageSize).ceil();
    String pageOfEventsUrl = '$events?size=$pageSize&page=$pageNo';

    List<T> newEvents = List();
    await Request()
        .getToMobileApi(resourcePath: pageOfEventsUrl)
        .then((response) {
      newEvents = _getList(json.decode(response.body))
          .map((event) => this.serializer(event))
          .toList();
    });

    setState(() {
      this._items.addAll(newEvents);
      this.isFetching = false;
    });
  }

  List _getList(var body) {
    var toReturn = body;
    this.keyList.forEach((key) => toReturn = toReturn[key]);
    return toReturn;
  }
}
