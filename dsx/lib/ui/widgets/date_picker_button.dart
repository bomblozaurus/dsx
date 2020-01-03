import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:flutter/material.dart';

typedef void PickedDateCallback(DateTime dateTime);

class DatePickerButton extends StatelessWidget {
  final String buttonDescription;
  final PickedDateCallback callback;

  const DatePickerButton(
      {Key key, @required this.buttonDescription, @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Null> _showDatePicker(BuildContext context) async {
      final DateTime now = DateTime.now();
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now.subtract(Duration(days: 1)),
          lastDate: now.add(Duration(days: 7)));
      callback(picked);
    }

    return InkWell(
      onTap: () => _showDatePicker(context),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.calendar_today,
              color: DsxTheme.Colors.loginGradientEnd,
            ),
            new Container(width: 4.0),
            new Text(this.buttonDescription ?? "",
                style: DsxTheme.TextStyles.descriptionTextStyleDark),
          ]),
    );
  }
}
