import 'package:dsx/models/reservation.dart';
import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:dsx/utils/requests.dart';
import 'package:dsx/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'date_picker_button.dart';

class ReservationForm extends StatefulWidget {
  final int roomId;

  const ReservationForm({Key key, this.roomId}) : super(key: key);

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  String _date, _hour, _duration;
  int _numberOfPeople, _currentStep = 0, _stepsNumber = 0;

  static const _darkGrey = DsxTheme.Colors.loginGradientEnd;
  static const _lime = DsxTheme.Colors.logoBackgroundColor;
  static var _darkStyle = DsxTheme.TextStyles.descriptionTextStyleDark;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.black,
          height: 50,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text("Rezerwuj",
                style: DsxTheme.TextStyles.headerTextStyle
                    .copyWith(fontSize: 42.0)),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: _lime,
          ),
          child: Theme(
            data: ThemeData(
              primaryColor: _darkGrey,
            ),
            child: Stepper(
              physics: NeverScrollableScrollPhysics(),
              onStepContinue: _onStepContinue,
              onStepCancel: _onStepCancel,
              onStepTapped: _onStepTapped,
              currentStep: _currentStep,
              steps: _steps(),
            ),
          ),
        )
      ],
    );
  }

  _submitReservation() async {
    _substringToInt(String string, int from, int to) =>
        int.parse(string.substring(from, to));
    _stringsToDateTime(String date, String time) {
      return DateTime(
          _substringToInt(date, 6, 10),
          _substringToInt(date, 3, 5),
          _substringToInt(date, 0, 2),
          _substringToInt(time, 0, 2),
          _substringToInt(time, 3, 5));
    }

    var reservation = Reservation(
        roomId: widget.roomId,
        dateTime: _stringsToDateTime(_date, _hour),
        duration: Time.fromDurationString(_duration),
        numberOfPeople: _numberOfPeople);

    var body = reservation.toJson();
    print(reservation);
    print(body);
    Request()
        .postToMobileApi(
        resourcePath: "/reservations", body: body, additionalHeaders: null)
        .then((response) {
      if (response.statusCode >= 200 && response.statusCode < 400) {
        setState(() {
          String empty;
          _date = empty;
          _hour = empty;
          _duration = empty;
          _numberOfPeople = null;
          _currentStep = 0;
        });
      }
    });
  }

  InputDecoration _inputDecoration(String label, IconData iconData) =>
      InputDecoration(
          prefixIcon: Icon(iconData, color: _darkGrey),
          labelText: label,
          labelStyle: TextStyle(color: _darkGrey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ));

  Widget _buildDatePicker() {
    return Theme(
        data: new ThemeData(
            accentColor: _lime,
            backgroundColor: _darkGrey,
            brightness: Brightness.dark),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: DatePickerField(
            callback: _setDate,
            decoration:
            _inputDecoration("Data wydarzenia", Icons.calendar_today),
          ),
        ));
  }

  Widget _buildHourChooser() {
    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DropdownButtonFormField(
          decoration:
          _inputDecoration("Godzina rozpoczęcia", Icons.access_time),
          style: _darkStyle,
          iconEnabledColor: _darkGrey,
          items: _getDropdownItems(_getHours()),
          selectedItemBuilder: (context) =>
              _getHours().map((String hour) {
                return Text(hour, style: _darkStyle);
              }).toList(),
          onChanged: (value) {
            (value is String)
                ? _setHourFrom(value)
                : throw ArgumentError("$value must be String!");
          },
          value: _hour,
        ),
      ),
    );
  }

  Widget _buildDurationChooser() {
    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DropdownButtonFormField(
          items: _getDropdownItems(_getDurations()),
          iconEnabledColor: _darkGrey,
          decoration: _inputDecoration("Czas trwania", Icons.timelapse),
          selectedItemBuilder: (context) =>
              _getDurations().map((String duration) {
                return Text(duration, style: _darkStyle);
              }).toList(),
          onChanged: (value) {
            value is String
                ? _setDuration(value)
                : throw ArgumentError("$value must be String!");
          },
          value: _duration,
        ),
      ),
    );
  }

  Widget _buildNumberOfPeopleChooser() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: TextField(
        onChanged: (String value) => _setNumberOfPeople(int.parse(value)),
        style: _darkStyle,
        decoration: _inputDecoration("Liczba osób", Icons.people),
        keyboardType: TextInputType.number,
      ),
    );
  }

  List<Step> _steps() {
    var steps = [
      SimpleStep(title: "Wybierz datę", content: _buildDatePicker()),
      SimpleStep(
          title: "Wybierz godzinę rozpoczęcia", content: _buildHourChooser()),
      SimpleStep(
          title: "Wybierz czas trwania", content: _buildDurationChooser()),
      SimpleStep(
          title: "Wybierz liczbę osób", content: _buildNumberOfPeopleChooser()),
    ];

    setState(() {
      _stepsNumber = steps.length;
    });

    return steps
        .asMap()
        .map((index, step) =>
        MapEntry(index, SimpleStep.toStep(index, step, _currentStep)))
        .values
        .toList();
  }

  _setStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  List<DropdownMenuItem> _getDropdownItems(List items) {
    return items
        .map((hour) =>
        DropdownMenuItem(
          child: Text(hour, style: TextStyle(color: Colors.white)),
          value: hour,
        ))
        .toList();
  }

  void _setHourFrom(dynamic hour) {
    setState(() {
      _hour = hour;
    });
  }

  void _setDuration(dynamic duration) {
    setState(() {
      _duration = duration;
    });
  }

  _setNumberOfPeople(int number) {
    setState(() {
      _numberOfPeople = number;
    });
  }

  _setDate(String date) {
    setState(() {
      _date = date;
    });
  }

  _onStepCancel() => (_currentStep != 0) ? _setStep(--_currentStep) : null;

  _onStepContinue() =>
      (_currentStep != _stepsNumber - 1)
          ? _setStep(++_currentStep)
          : _submitReservation();

  _onStepTapped(int index) => _setStep(index);

  List<String> _getHours() => ["11:00", "12:00", "14:14", "13:00", "12:12"];

  List<String> _getDurations() => ["0:30", "1:00", "1:30", "2:00"];
}

class SimpleStep {
  final String title;
  final Widget content;

  SimpleStep({this.title, this.content});

  static Step toStep(int index, SimpleStep step, int currentStep) {
    return Step(
        title: Text(step.title),
        isActive: index == currentStep,
        state: currentStep > index
            ? StepState.complete
            : currentStep < index ? StepState.indexed : StepState.editing,
        content: step.content);
  }
}

class ReservationRequest {
  final String date, hour, duration;
  final int numberOfPeople, roomId;

  ReservationRequest(
      {this.date, this.hour, this.duration, this.numberOfPeople, this.roomId});
}
