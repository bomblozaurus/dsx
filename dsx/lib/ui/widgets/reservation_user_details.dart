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
  Widget buildTitle(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          reservation.roomName,
          style: Theme.TextStyles.headerTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
      );

  @override
  List<Widget> getDetailsColumnWidgets(BuildContext context) =>
      [
        buildIconWithDescription(
            value: reservation.duration.toString(),
            icon: Icon(Icons.timelapse, color: Colors.white)),
        buildIconWithDescription(
            value: "${reservation.price} PLN",
            icon: Icon(Icons.monetization_on, color: Colors.white)),
        buildIconWithDescription(
            value: reservation.numberOfPeople.toString(),
            icon: Icon(Icons.people, color: Colors.white))
      ];
}
