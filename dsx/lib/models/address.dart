import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final String city;
  final String street;
  final int houseNumber;
  final int apartmentNumber;
  final String zip;

  Address(
      {this.city,
      this.street,
      this.houseNumber,
      this.apartmentNumber,
      this.zip});

  static Address fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String toString() {
    return '$city, $street $houseNumber/$apartmentNumber';
  }
}
