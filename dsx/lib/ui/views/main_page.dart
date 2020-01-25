import 'package:dsx/models/scope.dart';
import 'package:dsx/models/user_details.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/views/browse_ads_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/navigable.dart';
import 'browse_events_page.dart';
import 'browse_rooms_page.dart';

class MainPageState extends State<MainPage> {
  int _selectedPage = 1;

  List _getPageOptions(BuildContext context) {
    var options = [
      BrowseEventsPage(),
      BrowseAdsPage(),
    ];

    final UserDetails _userDetails = Provider.of<UserDetails>(context);
    if (_userDetails?.scope == Scope.DORMITORY) {
      options.insert(0, BrowseRoomsPage());
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        body: _getPageOptions(context)[_selectedPage],
        bottomNavigationBar: SizedBox(
          height: 68.0,
          child: BottomNavigationBar(
              currentIndex: _selectedPage,
              elevation: 100.0,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.Colors.logoBackgroundColor,
              showSelectedLabels: false,
              selectedIconTheme: IconThemeData(color: Colors.black, size: 40.0),
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
    ));
  }

  List<BottomNavigationBarItem> _buildNavigationBarItems() {
    return _getPageOptions(context)
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
