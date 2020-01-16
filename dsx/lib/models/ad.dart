import 'package:dsx/utils/fetchable.dart';
import 'package:dsx/utils/link.dart';
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';

part 'ad.g.dart';

@JsonSerializable()
class Ad implements Fetchable {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final Address address;

  Ad(
      {this.id,
      this.name,
      this.price,
      this.description,
      this.imageUrl,
      this.address});

  static Ad fromJson(Map<String, dynamic> json) {
    List links = json['links'].map((link) => Link.fromJson(link)).toList();
    final Address address = Address(
        city: json['city'] as String,
        street: json['street'] as String,
        houseNumber: json['houseNumber'] as int,
        apartmentNumber: json['apartmentNumber'] as int,
        zip: json['zip'] as String);

    return Ad(
        id: json['id'] as int,
        name: json['name'] as String,
        price: (json['price'] as num)?.toDouble(),
        description: json['description'] as String,
        imageUrl: links.firstWhere((link) => link.rel == 'mainImage').href,
        address: address);
  }

  Map<String, dynamic> toJson() => _$AdToJson(this);

  @override
  List<String> urls() => [imageUrl];
}
