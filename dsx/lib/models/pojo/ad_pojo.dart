import 'package:json_annotation/json_annotation.dart';

part 'ad_pojo.g.dart';

@JsonSerializable()
class AdPOJO {
  final String name;
  final double price;
  final String street;
  final int houseNumber;
  final int apartmentNumber;
  final String city;
  final String zip;
  final String description;
  final int mainImage;
  final String scope;

  AdPOJO(
      {this.name,
      this.price,
      this.street,
      this.houseNumber,
      this.apartmentNumber,
      this.city,
      this.zip,
      this.description,
      this.mainImage,
      this.scope});

  Map<String, dynamic> toJson() => _$AdPOJOToJson(this);
}
