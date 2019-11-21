import 'package:json_annotation/json_annotation.dart';
part 'room.g.dart';

@JsonSerializable()

class Room extends Object{
  final int id, ds_number;
  final String name;

  Room({this.id, this.ds_number, this.name});

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  static List<Room> roomListFromJson(List<dynamic> parsedJson) {

    List<Room> rooms = new List<Room>();
    rooms = parsedJson.map((i)=>Room.fromJson(i)).toList();
    return rooms;
  }
  Map<String, dynamic> toJson() => _$RoomToJson(this);


}