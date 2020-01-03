import '../utils/fetchable.dart';
import '../utils/time.dart';

class Room implements Fetchable {
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
      Time.fromString(json['openFrom']),
      Time.fromString(json['openTo']),
      Time.fromDuration(json['rentInterval']),
      (json['pricePerInterval'] as num));

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

  @override
  List<String> urls() => ['https://picsum.photos/${300 + id}'];
}