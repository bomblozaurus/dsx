import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'date_picker_button.dart';

class ReservationForm extends StatefulWidget {
  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  TextEditingController _dateInputController;

  @override
  void initState() {
    super.initState();
    _dateInputController = TextEditingController()
      ..text = _dateTimeToDate(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
    _dateInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _halfWidthWidget(Widget child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: child,
      );
    }

    Widget _twoElementsRow({Widget left, Widget right}) {
      return SizedBox(
        height: 34.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _halfWidthWidget(left),
            _halfWidthWidget(right),
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          height: 90,
          color: DsxTheme.Colors.logoBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _twoElementsRow(
                left: _buildDatePicker(),
                right: _buildDateTextField(),
              ),
              _twoElementsRow(
                  left: _buildChooseHour(), right: _buildHourChooser()),
            ],
          ),
        ),
      ],
    );
  }

  _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Theme(
          data: new ThemeData(
              accentColor: DsxTheme.Colors.logoBackgroundColor,
              backgroundColor: DsxTheme.Colors.loginGradientEnd,
              brightness: Brightness.dark),
          child: DatePickerButton(
            buttonDescription: "Data rezerwacji:",
            callback: _processDateTime,
          )),
    );
  }

  _processDateTime(DateTime dateTime) {
    this._dateInputController.text =
        dateTime != null ? _dateTimeToDate(dateTime) : "";
  }

  String _dateTimeToDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
  }

  _buildDateTextField() {
    return _buildInput(
      isFirst: true,
      child: TextField(
        readOnly: true,
        controller: _dateInputController,
        style: DsxTheme.TextStyles.descriptionTextStyle,
        textAlign: TextAlign.center,
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _buildHourChooser() {
    return _buildInput(
        child: Theme(
      data: new ThemeData(
          accentColor: DsxTheme.Colors.logoBackgroundColor,
          backgroundColor: DsxTheme.Colors.loginGradientEnd,
          brightness: Brightness.dark),
      child: DropdownButton(
        items: _getDropdownItems(),
        onChanged: (value) => print(value),
      ),
    ));
  }

  Widget _buildChooseHour() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 8.0,
        ),
        Icon(
          Icons.access_time,
          color: DsxTheme.Colors.loginGradientEnd,
        ),
        SizedBox(
          width: 4.0,
        ),
        Text("Godzina rezerwacji:",
            style: DsxTheme.TextStyles.descriptionTextStyleDark),
      ],
    );
  }

  Widget _buildInput(
      {bool isFirst = false, bool isLast = false, Widget child}) {
    assert(
        (!isFirst && !isLast) || (isFirst && !isLast) || (isLast && !isFirst));
    const darkGrey = DsxTheme.Colors.loginGradientEnd;
    var inputBackgroundColor =
        Color.fromRGBO(darkGrey.red, darkGrey.green, darkGrey.blue, 0.6);

    var topRadius = Radius.circular(isFirst ? 25.0 : 0);
    var bottomRadius = Radius.circular(isLast ? 25.0 : 0);

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        height: 32.0,
        width: 135.0,
        decoration: BoxDecoration(
            color: inputBackgroundColor,
            borderRadius:
                BorderRadius.vertical(top: topRadius, bottom: bottomRadius)),
        child: Align(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  _getDropdownItems() {
    return ["11:00", "12:00", "14:14", "13:00", "12:12"]
        .map((hour) => DropdownMenuItem(
              child: Text(hour),
              value: hour,
            ))
        .toList();
  }
}
