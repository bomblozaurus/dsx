import 'package:dsx/models/user_details.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/views/browse_ads_page.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/navigable.dart';
import 'browse_events_page.dart';
import 'browse_rooms_page.dart';

class MainPageState extends State<MainPage> {
  int _selectedPage = 0;
  final _pageOptions = [
    BrowseRoomsPage(),
    BrowseEventsPage(),
    BrowseAdsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureProvider<UserDetails>(
      child: MaterialApp(
          home: SafeArea(
        child: Scaffold(
          body: _pageOptions[_selectedPage],
          bottomNavigationBar: SizedBox(
            height: 68.0,
            child: BottomNavigationBar(
                currentIndex: _selectedPage,
                elevation: 100.0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.Colors.logoBackgroundColor,
                showSelectedLabels: false,
                selectedIconTheme:
                    IconThemeData(color: Colors.black, size: 40.0),
                selectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold, height: 0),
                unselectedIconTheme:
                    IconThemeData(color: Colors.black, size: 28.0),
                unselectedLabelStyle: TextStyle(
                    height: 1.0,
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                onTap: (int index) {
                  setState(() {
                    _selectedPage = index;
                  });
                },
                items: _buildNavigationBarItems()),
          ),
        ),
      )),
      create: (BuildContext context) async {
        return await JwtTokenUtils().getUserDetails();
      },
    );
  }

  List<BottomNavigationBarItem> _buildNavigationBarItems() {
    return _pageOptions
        .map((widget) => widget as Navigable)
        .map((navigable) => BottomNavigationBarItem(
            icon: Icon(navigable.getIconData()),
            title: Text(navigable.getDescription().toUpperCase())))
        .toList();
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}
