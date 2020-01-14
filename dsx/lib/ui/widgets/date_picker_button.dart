import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:flutter/material.dart';

typedef void PickedDateCallback(String date);

class DatePickerField extends StatefulWidget {
  final PickedDateCallback callback;
  final InputDecoration decoration;

  const DatePickerField(
      {Key key, @required this.decoration, @required this.callback})
      : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  TextEditingController _dateInputController;

  @override
  void initState() {
    super.initState();
    _dateInputController = TextEditingController();
    _dateInputController.text = _processDateTime(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.callback(_dateInputController.text));
  }

  @override
  void dispose() {
    super.dispose();
    _dateInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _showDatePicker(BuildContext context) async {
      final DateTime now = DateTime.now();
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now.subtract(Duration(days: 1)),
          lastDate: now.add(Duration(days: 7)));

      var readableDate = _processDateTime(picked);

      setState(() {
        _dateInputController.text = readableDate;
      });

      widget.callback(readableDate);
    }

    return TextField(
        onTap: () => _showDatePicker(context),
        decoration: this.widget.decoration,
        readOnly: true,
        style: DsxTheme.TextStyles.descriptionTextStyleDark,
        controller: _dateInputController);
  }

  _processDateTime(DateTime dateTime) {
    return dateTime != null ? _dateTimeToDate(dateTime) : "";
  }

  String _dateTimeToDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
  }
}
