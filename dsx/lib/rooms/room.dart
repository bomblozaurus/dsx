import 'package:json_annotation/json_annotation.dart';
part 'room.g.dart';

@JsonSerializable()

class Room extends Object{
  final int id, ds_number;
  final String name;

  Room({this.id, this.ds_number, this.name});

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}