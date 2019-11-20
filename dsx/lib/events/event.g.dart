// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      json['name'] as String,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['street'] as String,
      json['houseNumber'] as int,
      json['apartmentNumber'] as int,
      json['city'] as String,
      json['zip'] as String,
      json['description'] as String,
      json['scope'] as String,
      json['studentHouse'] as String);
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
