import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

import '../../utils/navigable.dart';
import 'events_page.dart';

class MainPageState extends State<MainPage> {
  int _selectedPage = 0;
  final _pageOptions = [
    BrowseEventsPage(),
    BrowseEventsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: _pageOptions[_selectedPage],
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
            unselectedIconTheme: IconThemeData(color: Colors.black, size: 28.0),
            unselectedLabelStyle: TextStyle(
              height: 1.0,
              color: Colors.black,
            ),
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
              });
            },
            items: _buildNavigationBarItems()),
      ),
    ));
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
