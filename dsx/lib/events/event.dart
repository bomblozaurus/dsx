import 'package:json_annotation/json_annotation.dart';
part 'event.g.dart';

@JsonSerializable()

class Event extends Object{
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


  Event({this.name, this.date, this.street, this.houseNumber,
      this.apartmentNumber, this.city, this.zip, this.description, this.scope,
      this.studentHouse});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}