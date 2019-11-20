import 'package:dsx/rooms/room.dart';

class RoomList {
  final List<Room> rooms;

  RoomList({
    this.rooms,
  });
  factory RoomList.fromJson(List<dynamic> parsedJson) {

    List<Room> rooms = new List<Room>();
    rooms = parsedJson.map((i)=>Room.fromJson(i)).toList();
    return new RoomList(
      rooms: rooms,
    );
  }


}
