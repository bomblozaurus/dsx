import 'package:flutter/material.dart';

class FutureText extends StatelessWidget {
  final Future<String> futureText;
  final TextStyle style;
  final TextOverflow overflow;

  const FutureText({Key key, this.futureText, this.style, this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureText,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data,
              style: style,
            );
          } else {
            return Text(
              "",
              style: style,
            );
          }
        });
  }
}
