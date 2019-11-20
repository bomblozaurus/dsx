
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  String _date = "Nie wybrana";
  String _time = "Nie wybrana";
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _description;
  int _houseNumber;
  int _apartmentNumber;
  String _street;
  String _city;
  String _zip;
  String _scope;
  String _studentHouse;
  TextEditingController _nameEventController = new TextEditingController();

  int _year, _month, _day, _hour, _minute, _second;

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
                                onSaved: (val) =>
                                    setState(() => _description = val)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Numer domu:'),
                                keyboardType: TextInputType.number,
                                onSaved: (val) =>
                                    setState(() => _houseNumber = val as int)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Numer mieszkania:'),
                                keyboardType: TextInputType.number,
                                onSaved: (val) =>
                                    setState(() => _apartmentNumber = val as int)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Ulica:'),
                                onSaved: (val) =>
                                    setState(() => _street = val)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Miasto:'),
                                onSaved: (val) =>
                                    setState(() => _city = val)),
                            TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Kod pocztowy:'),
                                keyboardType: TextInputType.number,
                                onSaved: (val) =>
                                    setState(() => _zip = val)),
                            new DropdownButton<String>(
                              items: <String>['Wszyscy', 'Studenci', 'Akademik'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              hint: Text("Wybierz zasięg ogłoszenia"),
                              onChanged: (newVal) {
                                if(newVal=='Wszyscy') {
                                  setState(() => _scope = "OTHER");
                                }
                                if(newVal=='Studenci') {
                                  setState(() => _scope = "STUDENTS");
                                }
                                if(newVal=='Akademik') {
                                  setState(() => _scope = "DORMITORY");
                                }
                              },
                            ),
                            new DropdownButton<String>(
                              items: <String>['DS1', 'DS2', 'DS3','DS4','DS5','DS6','DS7','DS8','DS9'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              hint: Text("Wybierz zasięg ogłoszenia"),
                              onChanged: (newVal) {
                                setState(() => _studentHouse = newVal);
                              },
                            ),
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
          )
        ],
      ),
    );
  }

/*  _createEvent() async {

    var event = Event(
        name: _name,
        date: new DateTime(_year,_month,_day,_hour,_minute,_second),
        street: _street,
      houseNumber: _houseNumber,
      apartmentNumber: _apartmentNumber,
      city: _city,
      zip: _zip,
      description: _description,
      scope:_scope,
      studentHouse: _studentHouse
    );
    var data = event.toJson();

    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("signUpUrl");
    var headers = Request.jsonHeader;

    await Request().createPost(url, body: data, headers: headers).then(
            (value) => showInSnackBar("Zarejestrowano pomyślnie!", Colors.blue));
  }*/
}
