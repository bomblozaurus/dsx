import 'package:flutter/material.dart';

class DatePickerButton extends StatefulWidget {
  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  @override
  Widget build(BuildContext context) {
    Future<Null> _showDatePicker(BuildContext context) async {
      final DateTime now = DateTime.now();
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now.subtract(Duration(days: 1)),
          lastDate: now.add(Duration(days: 7)));
      print(picked);
    }

    Color hexToColor(int rgb) => new Color(0xFF000000 + rgb);

    Color blueDark = hexToColor(0x335C81);
    Color blueLight = hexToColor(0x74B3CE);
    Color yellow = hexToColor(0xFCA311);
    Color red = hexToColor(0xE15554);
    Color green = hexToColor(0x3BB273);

    return Theme(
        data: new ThemeData(
          primaryColor: blueDark,
          accentColor: yellow,
          cardColor: blueLight,
          backgroundColor: blueDark,
          highlightColor: red,
          splashColor: green,
        ),
        child: FlatButton(
          color: Colors.black,
          child: Text("Wybierz"),
          onPressed: () => _showDatePicker(context),
        ));
  }
}
