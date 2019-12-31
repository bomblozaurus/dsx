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
  final String query;

  const LazyLoadedList(
      {@required this.pageSize,
      @required this.resourcePath,
      @required this.serializer,
      @required this.creator,
      @required this.keyList,
      this.query});

  @override
  _LazyLoadedListState createState() => _LazyLoadedListState<T>(
      pageSize: this.pageSize,
      resourcePath: this.resourcePath,
      serializer: this.serializer,
      keyList: this.keyList,
      itemCreator: this.creator,
      query: this.query);
}

class _LazyLoadedListState<T> extends State<LazyLoadedList> {
  Set _items = LinkedHashSet<T>();
  ScrollController _scrollController = ScrollController();
  bool isFetching;
  final String query;

  final int pageSize;
  final String resourcePath;
  final Function serializer;
  final ItemCreator itemCreator;
  final List<String> keyList;

  _LazyLoadedListState({
    @required this.pageSize,
    @required this.resourcePath,
    @required this.serializer,
    @required this.keyList,
    @required this.itemCreator,
    this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(child: _determineIfFetching()),
        ListView.builder(
            shrinkWrap: true,
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
    _fetchItems();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchItems();
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

  _fetchItems() async {
    setState(() {
      this.isFetching = true;
    });
    int pageNo = (_items.length / this.pageSize).ceil();
    String pageOfItemsUrl = '$resourcePath?size=$pageSize&page=$pageNo';

    List<T> newItems = List();
    await Request()
        .getToMobileApi(resourcePath: pageOfItemsUrl)
        .then((response) {
      newItems = _getList(json.decode(utf8.decode(response.bodyBytes)))
          .map((item) => this.serializer(item))
          .toList();
    });

    setState(() {
      this._items.addAll(newItems);
      this.isFetching = false;
    });
  }

  List _getList(var body) {
    var toReturn = body;
    this.keyList.forEach((key) => toReturn = toReturn[key]);
    return toReturn;
  }
}
