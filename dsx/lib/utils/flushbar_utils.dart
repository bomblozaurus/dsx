import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarUtils {
  static void showConnectionTimeout(BuildContext context) {
    FlushbarUtils.showFlushbar(
      context: context,
      title: "Przekroczono czas połączenia",
      message:
          "Sprawdź połączenie swoje połączenie z internetem i spróbuj zalogować się ponownie",
      color: Colors.red,
      icon: Icon(
        Icons.signal_cellular_connected_no_internet_4_bar,
        color: Colors.white,
      ),
    );
  }

  static void showFlushbar(
      {BuildContext context,
      String title,
      String message,
      Color color,
      Icon icon,
      Duration duration = const Duration(seconds: 5)}) {
    Flushbar(
      title: title,
      message: message,
      backgroundColor: color,
      icon: icon,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: duration,
    )..show(context);
  }
}
