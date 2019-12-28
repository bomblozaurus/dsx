import '../utils/time.dart';

class Room extends Object {
  final int id;
  final String name;
  final String description;
  final int dsNumber;
  final Time openFrom;
  final Time openTo;
  final Time rentInterval;
  final double pricePerInterval;

  Room(this.id, this.dsNumber, this.name, this.description, this.openFrom,
      this.openTo, this.rentInterval, this.pricePerInterval);

  static Room fromJson(Map<String, dynamic> json) => Room(
      json['id'] as int,
      json['dsNumber'] as int,
      json['name'] as String,
      json['description'] as String,
      json['openFrom'] as Time,
      json['openTo'] as Time,
      json['rentInterval'] as Time,
      (json['pricePerInterval'] as num)?.toDouble());

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'dsNumber': dsNumber,
        'openFrom': openFrom.toJson(),
        'openTo': openTo.toJson(),
        'rentInterval': rentInterval.toJson(),
        'pricePerInterval': pricePerInterval
      };
}
