// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) {
  return Room(
      id:json['id'],
      ds_number:json['ds_number'],
      name:json['name']);
}


Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
  'id':instance.id,
  'ds_number':instance.ds_number,
  'name':instance.name
};
