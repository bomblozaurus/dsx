import 'dart:convert';

import 'package:dsx/models/reservation.dart';
import 'package:dsx/models/user_details.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/widgets/reservation_details.dart';
import 'package:dsx/utils/future_text.dart';
import 'package:dsx/utils/requests.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class ReservationKeyholderDetails extends ReservationDetails {
  final Reservation reservation;
  final int index;

  ReservationKeyholderDetails({this.reservation, this.index})
      : super(reservation: reservation, index: index);

  static ReservationKeyholderDetails fromReservation(
          dynamic reservation, dynamic index) =>
      ReservationKeyholderDetails(
        reservation: reservation,
        index: index,
      );

  @override
  getDetailsColumnWidgets() => [
        buildIconWithDescription(
            value: "", icon: Icon(Icons.delete, color: Colors.white)),
      ];

  Future<String> _getReservationOwner() {
    String resourcePath =
        GlobalConfiguration().getString("reservationOwnerUrl");
    return Request()
        .getToMobileApi(
            resourcePath: '$resourcePath?reservationId=${reservation.id}')
        .then((response) =>
            UserDetails.fromJson(json.decode(response.body)).name);
  }

  @override
  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: FutureText(
        futureText: _getReservationOwner(),
        style: Theme.TextStyles.headerTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
