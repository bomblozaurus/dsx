import 'dart:convert';

import 'package:dsx/models/reservation.dart';
import 'package:dsx/models/user_details.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/widgets/reservation_details.dart';
import 'package:dsx/utils/flushbar_utils.dart';
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
  getDetailsColumnWidgets(BuildContext context) => [
        InkWell(
          onTap: () => _switchReservation(context),
          child: Icon(
            Icons.done,
            size: 30.0,
            color: Colors.white,
          ),
        ),
        InkWell(
          onTap: () => _deleteReservation(context),
          child: Icon(
            Icons.delete,
            size: 30.0,
            color: Colors.white,
          ),
        )
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
  Widget buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: FutureText(
        futureText: _getReservationOwner(),
        style: Theme.TextStyles.headerTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _switchReservation(BuildContext context) {
    String resourcePath = GlobalConfiguration().getString("switchReservation");
    try {
      Request()
          .putToMobileApi(
          resourcePath: '$resourcePath?reservationId=${reservation.id}')
          .then((response) {
        var jsonBody = json.decode(utf8.decode(response.bodyBytes));
        _showStatusChangedSuccessfully(context, jsonBody);
      });
    } catch (e) {
      FlushbarUtils.showConnectionTimeout(context);
    }
  }

  void _deleteReservation(BuildContext context) {
    print("DELETE");
    try {
      String resourcePath = GlobalConfiguration().getString("reservationsUrl");
      Request()
          .deleteToMobileApi('$resourcePath?id=${reservation.id}')
          .then((response) {
        var deleted = json.decode(utf8.decode(response.bodyBytes));
        deleted == true
            ? _showReservationDeletedSuccessfully(context)
            : _showReservationDeleteFailed(context);
      });
    } catch (e) {
      FlushbarUtils.showConnectionTimeout(context);
    }
  }

  void _showReservationDeletedSuccessfully(BuildContext context) {
    FlushbarUtils.showFlushbar(
      context: context,
      title: "Sukces",
      message: "Rezerwacja usunięta",
      color: Theme.Colors.loginGradientEnd,
      icon: Icon(
        Icons.done,
        color: Theme.Colors.logoBackgroundColor,
      ),
    );
  }

  void _showReservationDeleteFailed(BuildContext context) {
    FlushbarUtils.showFlushbar(
      context: context,
      title: "Niepowodzenie!",
      message:
      "Rezerwacja nie została usunięta, odśwież listę i spróbuj ponownie",
      color: Theme.Colors.loginGradientEnd,
      icon: Icon(
        Icons.warning,
        color: Colors.red,
      ),
    );
  }

  void _showStatusChangedSuccessfully(BuildContext context, var jsonBody) {
    FlushbarUtils.showFlushbar(
      context: context,
      title: "Sukces",
      message: "Status został zmieniony",
      color: Theme.Colors.loginGradientEnd,
      icon: Icon(
        Icons.done,
        color: Theme.Colors.logoBackgroundColor,
      ),
    );
  }
}
