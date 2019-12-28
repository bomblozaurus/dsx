import 'package:flutter/material.dart';

class Time {
  final TimeOfDay time;

  Time(this.time);

  static Time fromJson(Map<String, dynamic> json) {
    return Time(TimeOfDay(
        hour: int.parse((json['time'] as String).substring(0, 1)),
        minute: int.parse((json['time'] as String).substring(3, 4))));
  }

  Map<String, dynamic> toJson() => {'time': '${time.hour}:${time.minute}:00'};
}
