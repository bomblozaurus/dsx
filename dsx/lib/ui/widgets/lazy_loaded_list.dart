import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

import '../../utils/indexable.dart';
import '../../utils/requests.dart';

typedef I ItemCreator<T, I extends Indexable>(T item, index);

class LazyLoadedList<T, I extends Indexable> extends StatefulWidget {
  final int pageSize;
  final String noDataMessage;
  final String resourcePath;
  final Function serializer;
  final Function
      itemCreator; //FIXME powinien być typ ItemCreator, ale nie da sie przekazac Indexable Function (dynamic, dynamic)
  final List<String> keyList;
  final Stream queryStream;
  final Stream fetchingStream;

  const LazyLoadedList(
      {@required this.pageSize,
      @required this.resourcePath,
      @required this.serializer,
      @required this.itemCreator,
      @required this.keyList,
      this.queryStream,
      this.fetchingStream,
      this.noDataMessage});

  @override
  _LazyLoadedListState createState() => _LazyLoadedListState<T>();
}

class _LazyLoadedListState<T> extends State<LazyLoadedList> {
  ScrollController _scrollController;
  Set _items = LinkedHashSet<T>();
  bool _isFetching;
  String _query = "";

  _LazyLoadedListState();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(child: _determineIfFetching()),
        ),
        _buildBody()
      ],
    );
  }

  Widget _buildBody() {
    return _items.length > 0 ? _buildListView() : _buildEmptyListMessage();
  }

  Widget _buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.itemCreator(_items.elementAt(index), index);
        });
  }

  @override
  void initState() {
    super.initState();
    _fetchItems();

    try {
      widget.queryStream?.listen((data) {
        setState(() {
          this._query = data;
          this._items.clear();
          if (!_isFetching) {
            _fetchItems();
          }
        });
      });

      widget.fetchingStream?.listen((data) {
        if (data == true) {
          _fetchItems();
        }
      });
    } catch (e) {}
    ;

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _fetchItems();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _determineIfFetching() {
    if (this._isFetching) {
      return Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation(Theme.Colors.logoBackgroundColor),
            strokeWidth: 5.0),
      );
    }
  }

  Future<void> _fetchItems() async {
    if (mounted) {
      setState(() {
        this._isFetching = true;
      });

      int pageNo = (_items.length / widget.pageSize).ceil();
      String pageOfItemsUrl =
          '${widget.resourcePath}?query=$_query&size=${widget
          .pageSize}&page=$pageNo';

      List<T> newItems = List();
      await Request()
          .getToMobileApi(resourcePath: pageOfItemsUrl)
          .then((response) {
        newItems = _getList(json.decode(utf8.decode(response.bodyBytes)))
            .map((item) => widget.serializer(item))
            .toList();
      });

      if (mounted) {
        setState(() {
          this._items.addAll(newItems);
          this._isFetching = false;
        });
      }
    }
  }

  List _getList(var body) {
    var toReturn = body;
    widget.keyList.forEach((key) => toReturn = toReturn[key]);
    return toReturn;
  }

  Widget _buildEmptyListMessage() {
    return _isFetching
        ? const SizedBox()
        : Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          widget.noDataMessage ?? "",
          style: Theme.TextStyles.headerTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
