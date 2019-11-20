
import 'package:dsx/requests/requests.dart';
import 'package:dsx/style/theme.dart'as Theme;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:global_configuration/global_configuration.dart';

import 'event.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final GlobalKey<ScaffoldState> _formKey = new GlobalKey<ScaffoldState>();
  String _date = "Nie wybrana";
  String _time = "Nie wybrana";
//  final _formKey = GlobalKey<FormState>();
  String _name;
  String _description;
  int _houseNumber;
  int _apartmentNumber;
  String _street;
  String _city;
  String _zip;
  String _scopeName;
  String _scope;
  String _studentHouse;
  TextEditingController _nameEventController = new TextEditingController();

  int _year, _month, _day, _hour, _minute, _second;

  List<String> _scopeList = ['Wszyscy', 'Studenci', 'Akademik']; // Option 2
  List<String> _studentHouseList = ['DS1', 'DS2', 'DS3','DS4','DS5','DS6','DS7','DS8','DS9'];
  String _selectedLocation; // Option 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Stwórz wydarzenie')),
        body: SingleChildScrollView(
          child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Builder(
                  builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration:
                              InputDecoration(labelText: 'Nazwa wydarzenia:'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Nazwa nie może być pusta';
                                }
                              },
                              onSaved: (val) =>
                                  setState(() => _name = val),
                            ),
                            buildTimePicker(context),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Opis:'),
                                onChanged: (val) =>
                                    setState(() => _description = val)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Numer domu:'),
                                keyboardType: TextInputType.number,
                                onChanged: (val) =>
                                    setState(() => _houseNumber = val as int)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Numer mieszkania:'),
                                keyboardType: TextInputType.number,
                                onChanged: (val) =>
                                    setState(() => _apartmentNumber = val as int)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Ulica:'),
                                onChanged: (val) =>
                                    setState(() => _street = val)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Miasto:'),
                                onChanged: (val) =>
                                    setState(() => _city = val)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Kod pocztowy:'),
                                keyboardType: TextInputType.number,
                                onSaved: (val) =>
                                    setState(() => _zip = val)),
                            DropdownButton(
                              hint: Text('Wybierz akademik:'), // Not necessary for Option 1
                              value: _studentHouse,
                              onChanged: (newValue) {
                                setState(() {
                                  _studentHouse = newValue;
                                });
                              },
                              items: _studentHouseList.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                             DropdownButton(
                              hint: Text('Wybierz zasięg ogłoszenia'), // Not necessary for Option 1
                              value: _scopeName,
                              onChanged: (newValue) {
                                setState(() {
                                  setState(() {
                                    _scopeName = newValue;
                                  });
                                  if(newValue=='Wszyscy') {
                                    setState(() => _scope = "OTHER");
                                  }
                                  if(newValue=='Studenci') {
                                    setState(() => _scope = "STUDENTS");
                                  }
                                  if(newValue=='Akademik') {
                                    setState(() => _scope = "DORMITORY");
                                  }
                                });
                              },
                              items: _scopeList.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
/*                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                child: RaisedButton(
                                    onPressed: () {
                                      final form = _formKey.currentState;
                                      if (form.validate()) {
                                        form.save();
                                        _user.save();
                                        _showDialog(context);
                                      }
                                    },
                                    child: Text('Save'))),*/
                            _buildSubmitButton("DODAJ", 340.0, () => _createEvent())
                          ])))),
        ));
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }



  Widget buildTimePicker(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            onPressed: () {
              DatePicker.showDatePicker(context,
                  theme: DatePickerTheme(
                    containerHeight: 210.0,
                  ),
                  showTitleActions: true,
                  minTime: DateTime(2019, 11, 20),
                  maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                    print('potwierdź $date');
                    _date = '${date.year} - ${date.month} - ${date.day}';
                    setState(() {_year=date.year;
                    _month=date.month;
                    _day=date.day;});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                            Text(
                              " $_date",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    "  Zmień",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            color: Colors.white,
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            onPressed: () {
              DatePicker.showTimePicker(context,
                  theme: DatePickerTheme(
                    containerHeight: 210.0,
                  ),
                  showTitleActions: true, onConfirm: (time) {
                    print('potwierdź $time');
                    _time = '${time.hour} : ${time.minute} : ${time.second}';
                    setState(() {_hour=time.hour;
                    _minute = time.minute;
                    _second = time.second;});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                            Text(
                              " $_time",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    "  Zmień",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value, Color color) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _formKey.currentState?.removeCurrentSnackBar();
    _formKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: Theme.Fonts.loginFontSize,
            fontFamily: Theme.Fonts.loginFontSemiBold),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }

  _createEvent() async {

    var event = Event1(
        name: "sad",
        date: new DateTime(_year,_month,_day,_hour,_minute,_second),
        street: "dsa",
      houseNumber: 2,
      apartmentNumber: 3,
      city: "dasd",
      zip: "23-123",
      description: "sada",
      scope: "DORMITORY",
      studentHouse: _studentHouse
    );
    var data = event.toJson();

    print(data);

    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("eventsUrl");
    var headers = Request.jsonHeader;

    await Request().createPost(url, body: data, headers: headers).then(
            (value) => print("Utworzono wydarzenie!"));
  }

  Container _buildSubmitButton(
      String text, double topMargin, Function() onPressed) {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.Colors.loginGradientStart,
            blurRadius: 20.0,
          ),
          BoxShadow(
            color: Theme.Colors.loginGradientEnd,
            blurRadius: 20.0,
          ),
        ],
        gradient: new LinearGradient(
            colors: [
              Theme.Colors.loginGradientEnd,
              Theme.Colors.loginGradientStart
            ],
            begin: const FractionalOffset(0.2, 0.2),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Theme.Colors.loginGradientEnd,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: Theme.Fonts.loginFontBold),
            ),
          ),
          onPressed: onPressed),
    );
  }
}
