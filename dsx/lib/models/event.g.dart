// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
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
      studentHouse: json['studentHouse'] as String);
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'name': instance.name,
      'date': instance.date?.toIso8601String(),
      'street': instance.street,
      'houseNumber': instance.houseNumber,
      'apartmentNumber': instance.apartmentNumber,
      'city': instance.city,
      'zip': instance.zip,
      'description': instance.description,
      'scope': instance.scope,
      'studentHouse': instance.studentHouse
    };
