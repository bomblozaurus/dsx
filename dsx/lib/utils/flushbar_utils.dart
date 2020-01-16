import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarUtils {
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
