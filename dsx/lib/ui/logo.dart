import 'package:dsx/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

class Logo extends StatelessWidget{
  final double size;

  const Logo({Key key, this.size}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.Colors.logoBackgroundColor,
            blurRadius: this.size * 0.075,
          ),
        ],
        color: Theme.Colors.logoBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(this.size)),
      ),
      child: Center(
        child: Text(
          "DSX",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black87,
              fontSize: size / 2.0,
              fontFamily: Theme.Fonts.logoFont),
        ),
      ),
    );
  }

}