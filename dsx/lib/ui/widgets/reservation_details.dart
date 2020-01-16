import 'package:dsx/models/reservation.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/utils/indexable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class ReservationDetails extends StatelessWidget implements Indexable {
  final Reservation reservation;
  final int index;

  const ReservationDetails({
    Key key,
    this.reservation,
    this.index,
  }) : super(key: key);

  List<Widget> getDetailsColumnWidgets();

  Widget buildTitle();

  @override
  Widget build(BuildContext context) {
    Widget _buildConfirmedInfo() {
      return DefaultTextStyle(
          style: Theme.TextStyles.subHeaderTextStyle,
          child: buildIconWithDescription(
              value: acceptedText(),
              icon: Icon(acceptedIcon(), color: acceptedColor())));
    }

    Widget _buildDate() {
      return DefaultTextStyle(
          style: Theme.TextStyles.subHeaderTextStyle,
          child: buildIconWithDescription(
              value: _dateTimeToReadable(reservation.dateTime),
              icon: Icon(Icons.calendar_today, color: Colors.white)));
    }

    Widget _buildBottomRow() {
      return Row(
        children: <Widget>[
          SizedBox(width: 16.0),
          _buildConfirmedInfo(),
          SizedBox(
            width: 16.0,
          ),
          _buildDate(),
        ],
      );
    }

    Widget _buildMainContent() {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildTitle(),
            _buildBottomRow(),
          ],
        ),
      );
    }

    Widget _buildDetailsColumn() {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: DefaultTextStyle(
            style: Theme.TextStyles.regularTextStyle,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getDetailsColumnWidgets())),
      );
    }

    Widget _buildContent() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildMainContent(),
          _buildSeparator(),
          _buildDetailsColumn(),
        ],
      );
    }

    return InkWell(
      child: Card(
        color: Theme.Colors.loginGradientEnd,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(height: 100, child: _buildContent()),
      ),
    );
  }

  Widget buildIconWithDescription({String value, Icon icon}) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          icon,
          Container(width: 4.0),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
        ]);
  }

  Container _buildSeparator() {
    return Container(
        width: 1.0,
        height: 80.0,
        color: Color.fromRGBO(acceptedColor().red, acceptedColor().green,
            acceptedColor().blue, 0.5));
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
