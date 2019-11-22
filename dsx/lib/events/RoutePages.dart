import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              child: Text('Ogłoszenia'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/adds',
                  arguments: 'Hello there from the first page!',
                );
              },
            ),
            RaisedButton(
              child: Text('Aktualności'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/news'
                );
              },
            ),
            RaisedButton(
              child: Text('Wydarzenia'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/events',
                  arguments: 'Hello there from the first page!',
                );
              },
            ),
            RaisedButton(
              child: Text('Rezerwacje'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/reservation',
                  arguments: 'Hello there from the first page!',
                );
              },
            ),
            RaisedButton(
              child: Text('Dodaj'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/add',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddPage extends StatelessWidget {
  // This is a String for the sake of an example.
  // You can use any type you want.
/*  final String data;

  AddPage({
    Key key,
    @required this.data,
  }) : super(key: key);*/

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              child: Text('Ogłoszenie'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/addAdd',
                );
              },
            ),
            RaisedButton(
              child: Text('Wydarzemie'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/addEvent',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShowScopePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybierz zasieg'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              child: Text('Akademik'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/scope',
                  arguments: 'DORMITORY',
                );
              },
            ),
            RaisedButton(
              child: Text('Studenci'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/scope',
                  arguments: 'STUDENT',
                );
              },
            ),
            RaisedButton(
              child: Text('Wszyscy'),
              onPressed: () {
                // Pushing a named route
                Navigator.of(context).pushNamed(
                  '/scope',
                  arguments: 'OTHER',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
