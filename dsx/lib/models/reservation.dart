import 'package:dsx/utils/time.dart';

class Reservation {
  final int roomId;
  final String roomName;
  final DateTime dateTime;
  final Time duration;
  final double price;
  final int numberOfPeople;
  final bool accepted;

  Reservation(
      {this.roomId,
      this.roomName,
      this.dateTime,
      this.duration,
      this.price,
      this.numberOfPeople,
      this.accepted});

  static Reservation fromJson(Map<String, dynamic> json) {
    return Reservation(
        roomId: json['roomId'] as int,
        roomName: json['roomName'] as String,
        dateTime: DateTime.parse(json['dateTime']) == null
            ? null
            : DateTime.parse(json['dateTime'] as String),
        duration: Time.fromDuration(json['duration']),
        price: json['price'] as double,
        numberOfPeople: json['numberOfPeople'] as int,
        accepted: json['accepted'] as bool);
  }
}
