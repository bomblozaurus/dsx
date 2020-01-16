import 'package:dsx/utils/link.dart';

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
  final String imageUrl;

  Room(this.id, this.dsNumber, this.name, this.description, this.openFrom,
      this.openTo, this.rentInterval, this.pricePerInterval, this.imageUrl);

  static Room fromJson(Map<String, dynamic> json) {
    List links = json['links'].map((link) => Link.fromJson(link)).toList();
    return Room(
        json['id'] as int,
        json['dsNumber'] as int,
        json['name'] as String,
        json['description'] as String,
        Time.fromString(json['openFrom']),
        Time.fromString(json['openTo']),
        Time.fromDuration(json['rentInterval']),
        (json['pricePerInterval'] as num),
        links.firstWhere((link) => link.rel == 'mainImage').href);
  }

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
  List<String> urls() => [imageUrl];
}
