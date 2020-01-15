import 'package:dsx/utils/time.dart';

class Reservation {
  final int id;
  final int roomId;
  final String roomName;
  final DateTime dateTime;
  final Time duration;
  final double price;
  final int numberOfPeople;
  final bool accepted;

  Reservation(
      {this.id,
      this.roomId,
      this.roomName,
      this.dateTime,
      this.duration,
      this.price,
      this.numberOfPeople,
      this.accepted});

  static Reservation fromJson(Map<String, dynamic> json) {
    return Reservation(
        id: json['id'] as int,
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

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'roomId': roomId,
        'roomName': roomName,
        'dateTime': dateTime?.toString()?.substring(0, 19),
        'duration': duration.toDurationJson(),
        'price': price,
        'numberOfPeople': numberOfPeople,
        'accepted': accepted,
      };
}
