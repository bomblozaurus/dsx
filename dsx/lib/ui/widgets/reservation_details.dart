import 'package:dsx/models/reservation.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/utils/indexable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReservationDetails extends StatelessWidget implements Indexable {
  final Reservation reservation;
  final int index;

  const ReservationDetails({Key key, this.reservation, this.index})
      : super(key: key);

  static ReservationDetails fromReservation(
      dynamic reservation, dynamic index) {
    return ReservationDetails(reservation: reservation, index: index);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildIconWithDescription({String value, Icon icon}) {
      return new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            icon,
            new Container(width: 4.0),
            new Text(value),
          ]);
    }

    Widget _buildContent() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    reservation.roomName,
                    style: Theme.TextStyles.headerTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 16.0),
                    DefaultTextStyle(
                        style: Theme.TextStyles.subHeaderTextStyle,
                        child: _buildIconWithDescription(
                            value: acceptedText(),
                            icon:
                                Icon(acceptedIcon(), color: acceptedColor()))),
                    SizedBox(
                      width: 16.0,
                    ),
                    DefaultTextStyle(
                        style: Theme.TextStyles.subHeaderTextStyle,
                        child: _buildIconWithDescription(
                            value: _dateTimeToReadable(reservation.dateTime),
                            icon: Icon(Icons.calendar_today,
                                color: Colors.white))),
                  ],
                ),
              ],
            ),
          ),
          Container(
              width: 1.0,
              height: 80.0,
              color: Color.fromRGBO(acceptedColor().red, acceptedColor().green,
                  acceptedColor().blue, 0.5)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DefaultTextStyle(
              style: Theme.TextStyles.regularTextStyle,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildIconWithDescription(
                      value: reservation.duration.toString(),
                      icon: Icon(Icons.timelapse, color: Colors.white)),
                  _buildIconWithDescription(
                      value: "${reservation.price} PLN",
                      icon: Icon(Icons.monetization_on, color: Colors.white)),
                  _buildIconWithDescription(
                      value: reservation.numberOfPeople.toString(),
                      icon: Icon(Icons.people, color: Colors.white))
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      color: Theme.Colors.loginGradientEnd,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(height: 100, child: _buildContent()),
    );
  }

  Color acceptedColor() =>
      reservation.accepted ? Theme.Colors.logoBackgroundColor : Colors.red;

  IconData acceptedIcon() =>
      reservation.accepted ? Icons.thumb_up : Icons.thumb_down;

  String acceptedText() =>
      reservation.accepted ? "Potwierdzona" : "Niepotwierdzona";

  String _dateTimeToReadable(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
