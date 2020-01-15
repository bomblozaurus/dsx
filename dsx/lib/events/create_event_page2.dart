import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/utils/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';

import '../models/event.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final GlobalKey<ScaffoldState> _formKey = GlobalKey<ScaffoldState>();
  String _date = "Data";
  String _time = "Czas";
  String _scopeName;
  String _scope;
  String _studentHouse;

  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeStreet = FocusNode();
  final FocusNode myFocusNodeCity = FocusNode();
  final FocusNode myFocusNodeZip = FocusNode();
  final FocusNode myFocusNodeDescription = FocusNode();
  final FocusNode myFocusNodeHouseNumber = FocusNode();
  final FocusNode myFocusNodeApartmentNumber = FocusNode();

  TextEditingController nameEventController = TextEditingController();
  TextEditingController streetEventController = TextEditingController();
  TextEditingController cityEventController = TextEditingController();
  TextEditingController zipEventController = TextEditingController();
  TextEditingController descriptionEventController = TextEditingController();
  TextEditingController houseNumberEventController = TextEditingController();
  TextEditingController apartmentNumberEventController =
      TextEditingController();

  int _year, _month, _day, _hour, _minute, _second;

  List<String> _scopeList = ['Wszyscy', 'Studenci', 'Akademik']; // Option 2
  List<String> _studentHouseList = [
    'DS1',
    'DS2',
    'DS3',
    'DS4',
    'DS5',
    'DS6',
    'DS7',
    'DS8',
    'DS9'
  ];

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
                            _buildTextField(
                                myFocusNodeName,
                                nameEventController,
                                TextInputType.text,
                                FontAwesomeIcons.user,
                                "Nazwa"),
                            _buildSeparator(),
                            _buildTextField(
                                myFocusNodeDescription,
                                descriptionEventController,
                                TextInputType.text,
                                FontAwesomeIcons.user,
                                "Opis"),
                            _buildSeparator(),
                            buildTimePicker(context),
                            _buildSeparator(),
                            _buildTextField(
                                myFocusNodeApartmentNumber,
                                apartmentNumberEventController,
                                TextInputType.number,
                                FontAwesomeIcons.user,
                                "Numer Mieszkania"),
                            _buildSeparator(),
                            _buildTextField(
                                myFocusNodeHouseNumber,
                                houseNumberEventController,
                                TextInputType.number,
                                FontAwesomeIcons.user,
                                "Numer Domu"),
                            _buildSeparator(),
                            _buildTextField(
                                myFocusNodeStreet,
                                streetEventController,
                                TextInputType.text,
                                FontAwesomeIcons.user,
                                "Ulica"),
                            _buildSeparator(),
                            _buildTextField(
                                myFocusNodeCity,
                                cityEventController,
                                TextInputType.text,
                                FontAwesomeIcons.user,
                                "Miasto"),
                            _buildSeparator(),
                            _buildTextField(
                                myFocusNodeZip,
                                zipEventController,
                                TextInputType.number,
                                FontAwesomeIcons.user,
                                "Kod pocztowy"),
                            _buildSeparator(),
                            DropdownButton(
                              hint: Text('Wybierz akademik:'), // Not necessary for Option 1
                              value: _studentHouse,
                              onChanged: (Value) {
                                setState(() {
                                  _studentHouse = Value;
                                });
                              },
                              items: _studentHouseList.map((location) {
                                return DropdownMenuItem(
                                  child: Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                                DropdownButton(
                                  hint: Text('Wybierz zasięg ogłoszenia'),
                                  // Not necessary for Option 1
                                  value: _scopeName,
                                  onChanged: (Value) {
                                    setState(() {
                                      setState(() {
                                        _scopeName = Value;
                                      });
                                      if (Value == 'Wszyscy') {
                                        setState(() => _scope = "OTHER");
                                      }
                                      if (Value == 'Studenci') {
                                        setState(() => _scope = "STUDENT");
                                      }
                                      if (Value == 'Akademik') {
                                        setState(() => _scope = "DORMITORY");
                                      }
                                    });
                                  },
                                  items: _scopeList.map((location) {
                                    return DropdownMenuItem(
                                      child: Text(location),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                                _buildSubmitButton(
                                    "DODAJ", 50.0, () => _createEvent())
                              ])))),
        ));
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }

  Widget _buildTextField(FocusNode focusNode, TextEditingController controller,
      TextInputType textInputType, IconData iconData, String text,
      {bool obscureText = false}) {
    return Padding(
        padding:
        EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: textInputType,
          obscureText: obscureText,
          style: TextStyle(
              fontFamily: Theme.Fonts.loginFontSemiBold,
              fontSize: Theme.Fonts.loginFontSize,
              color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: text,
            hintStyle: TextStyle(
                fontFamily: Theme.Fonts.loginFontSemiBold, fontSize: 17.0),
          ),
        ));
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
                  minTime: DateTime.now(),
                  maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
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
                    "  Wybierz",
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
                    "  Wybierz",
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
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState?.removeCurrentSnackBar();
    _formKey.currentState.showSnackBar(SnackBar(
      content: Text(
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

  Container _buildSeparator() {
    return Container(
      width: 250.0,
      height: 1.0,
      color: Colors.grey[400],
    );
  }

  _createEvent() async {
    String name = nameEventController.text;
    String street =streetEventController.text;
    int houseNumber = num.tryParse(streetEventController.text);
    int apartmentNumber = num.tryParse(apartmentNumberEventController.text) ;
    String city = cityEventController.text;
    String zip = zipEventController.text;
    String description = descriptionEventController.text;

    var event = Event(
        name: name,
        date: DateTime(_year, _month, _day, _hour, _minute, _second),
        street: street,
        houseNumber: houseNumber,
        apartmentNumber: apartmentNumber,
        city: city,
        zip: zip,
        description: description,
        scope: _scope,
        studentHouse: _studentHouse
    );
    var data = event.toJson();

    print(data);

    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("eventsUrl");
    var headers = Request.jsonHeader;

    await Request().createPost(url, body: data, headers: headers).then(
            (value) => print("Zarejestrowano pomyślnie!"));
  }

/*  Container _buildSubmitButton(
      String text, double topMargin, Function() onPressed) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.Colors.loginGradientStart,
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
          BoxShadow(
            color: Theme.Colors.loginGradientEnd,
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
        ],
        gradient:  LinearGradient(
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
  }*/

  Container _buildSubmitButton(
      String text, double topMargin, Function() onPressed) {
    return Container(
      decoration: BoxDecoration(
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
        gradient: LinearGradient(
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
