import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()

class User extends Object{
  final String password, email, firstName, lastName;

  User({this.password, this.email, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}