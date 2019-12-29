import 'package:flutter/material.dart';

class Time {
  final TimeOfDay time;

  Time(this.time);

  static Time fromJson(Map<String, dynamic> json) {
    String string = json['time'] as String;
    string = string.substring(1, string.length - 2);
    return Time.fromString(string);
  }

  static Time fromString(String string) {
    return Time(TimeOfDay(
        hour: int.parse(string.substring(0, 2)),
        minute: int.parse(string.substring(3, 5))));
  }

  Map<String, dynamic> toJson() => {'time': '${toString()}:00'};

  bool operator >=(Time time) {
    return (this == time ||
        (this.time.hour > time.time.hour) ||
        (this.time.hour == time.time.hour &&
            this.time.minute > this.time.minute));
  }

  bool operator <=(Time time) {
    return (!(this >= time) || this == time);
  }

  bool operator ==(dynamic object) {
    bool toReturn = object is Time;
    if (toReturn) {
      Time time = object as Time;
      toReturn &= time.time == this.time;
    }
    return toReturn;
  }

  @override
  int get hashCode {
    return 113 * this.time.hashCode;
  }

  @override
  String toString() {
    String minute =
        (time.minute < 10) ? '0${time.minute}' : time.minute.toString();
    return '${time.hour}:$minute';
  }
}
