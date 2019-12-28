import 'dart:collection';
import 'dart:convert';

import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

import '../../utils/indexable.dart';
import '../../utils/requests.dart';

typedef I ItemCreator<T, I extends Indexable>(T item, index);

class LazyLoadedList<T, I extends Indexable> extends StatefulWidget {
  final int pageSize;
  final String resourcePath;
  final Function serializer;
  final Function
      creator; //FIXME powinien być typ ItemCreator, ale nie da sie przekazac Indexable Function (dynamic, dynamic)
  final List<String> keyList;

  const LazyLoadedList(
      {@required this.pageSize,
      @required this.resourcePath,
      @required this.serializer,
      @required this.creator,
      @required this.keyList});

  @override
  _LazyLoadedListState createState() => _LazyLoadedListState<T>(
      pageSize: this.pageSize,
      resourcePath: this.resourcePath,
      serializer: this.serializer,
      keyList: this.keyList,
      itemCreator: this.creator);
}

class _LazyLoadedListState<T> extends State<LazyLoadedList> {
  Set _items = LinkedHashSet<T>();
  ScrollController _scrollController = ScrollController();
  bool isFetching;

  final int pageSize;
  final String resourcePath;
  final Function serializer;
  final ItemCreator itemCreator;
  final List<String> keyList;

  _LazyLoadedListState(
      {@required this.pageSize,
      @required this.resourcePath,
      @required this.serializer,
      @required this.keyList,
      @required this.itemCreator});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(child: _determineIfFetching()),
        ListView.builder(
            controller: _scrollController,
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              return this.itemCreator(_items.elementAt(index), index);
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
          valueColor: AlwaysStoppedAnimation(Theme.Colors.logoBackgroundColor),
          strokeWidth: 5.0);
    }
  }

  _fetchEvents() async {
    setState(() {
      this.isFetching = true;
    });
    int pageNo = (_items.length / this.pageSize).ceil();
    String pageOfEventsUrl = '$resourcePath?size=$pageSize&page=$pageNo';

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
