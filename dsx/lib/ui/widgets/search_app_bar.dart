import 'package:dsx/utils/jwt_token.dart';
import 'package:flutter/material.dart';

import '../../style/theme.dart' as Theme;

class SearchAppBar extends StatefulWidget {
  final Function search;

  const SearchAppBar({Key key, this.search}) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _detailsColor = Colors.white;

    return SliverAppBar(
      backgroundColor: Colors.black,
      primary: true,
      pinned: false,
      floating: true,
      centerTitle: true,
      snap: true,
      title: _buildTitle(context, _detailsColor),
    );
  }

  Widget _buildTitle(BuildContext context, Color _detailsColor) {
    return Row(
      children: <Widget>[
        _buildLogoutIcon(context),
        SizedBox(
          width: 8.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.81,
          height: 40.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
              color: Theme.Colors.loginGradientEnd),
          child: Row(
            children: <Widget>[
              _buildInput(_detailsColor),
              _buildSearchIcon(_detailsColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutIcon(context) => InkWell(
      onTap: () => JwtTokenUtils().logout(context),
      child: Icon(Icons.exit_to_app));

  Padding _buildSearchIcon(Color _detailsColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: _search,
        child: Icon(Icons.search, color: _detailsColor, size: 32.0),
      ),
    );
  }

  _search() {
    widget.search(_inputController.text);
  }

  Flexible _buildInput(Color _detailsColor) {
    return Flexible(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 8.0),
          child: TextField(
            textInputAction: TextInputAction.search,
            onEditingComplete: _search,
            cursorColor: _detailsColor,
            controller: _inputController,
            decoration: InputDecoration(
              border: InputBorder.none,
              helperStyle: TextStyle(
                color: _detailsColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextStyle(
              color: _detailsColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }
}
