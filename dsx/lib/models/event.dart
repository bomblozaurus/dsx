import 'package:dsx/utils/link.dart';

import '../utils/fetchable.dart';

class Event extends Object implements Fetchable {
  final String name;
  final DateTime date;
  final String street;
  final int houseNumber;
  final int apartmentNumber;
  final String city;
  final String zip;
  final String description;
  final String scope;
  final String studentHouse;
  final String imageUrl;

  Event({
    this.name,
    this.date,
    this.street,
    this.houseNumber,
    this.apartmentNumber,
    this.city,
    this.zip,
    this.description,
    this.scope,
    this.studentHouse,
    this.imageUrl,
  });

  String getAddress() {
    return '$city, $street $houseNumber/$apartmentNumber';
  }

  String getDate() {
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String getTime() {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String getDateTime() {
    var date = this.date.toLocal();
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static Event fromJson(Map<String, dynamic> json) {
    List links = json['links'].map((link) => Link.fromJson(link)).toList();
    return Event(
      name: json['name'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      street: json['street'] as String,
      houseNumber: json['houseNumber'] as int,
      apartmentNumber: json['apartmentNumber'] as int,
      city: json['city'] as String,
      zip: json['zip'] as String,
      description: json['description'] as String,
      scope: json['scope'] as String,
      studentHouse: json['studentHouse'] as String,
      imageUrl: links.firstWhere((link) => link.rel == 'mainImage').href,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': this.name,
        'date': this.date?.toIso8601String(),
        'street': this.street,
        'houseNumber': this.houseNumber,
        'apartmentNumber': this.apartmentNumber,
        'city': this.city,
        'zip': this.zip,
        'description': this.description,
        'scope': this.scope,
        'studentHouse': this.studentHouse
      };

  @override
  List<String> urls() => List<String>.of([this.imageUrl]);
}
