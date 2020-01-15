import 'package:dsx/models/reservation.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/widgets/reservation_details.dart';
import 'package:flutter/material.dart';

class ReservationUserDetails extends ReservationDetails {
  final Reservation reservation;
  final int index;

  ReservationUserDetails({this.reservation, this.index})
      : super(reservation: reservation, index: index);

  static ReservationDetails fromReservation(
          dynamic reservation, dynamic index) =>
      ReservationUserDetails(
        reservation: reservation,
        index: index,
      );

  @override
  Function onDoubleTap() {
    // TODO: implement onDoubleTap
    return null;
  }

  @override
  Function onLongPress() {
    // TODO: implement onLongPress
    return null;
  }

  @override
  Widget buildTitle() => Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          reservation.roomName,
          style: Theme.TextStyles.headerTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
      );

  @override
  List<Widget> getDetailsColumnWidgets() {
    // TODO: implement getDetailsColumnWidgets
    return null;
  }
}
