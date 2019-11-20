import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()

class User{
  final String password, email, firstName, lastName;

  User({this.password, this.email, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class LogInCredentials{
  final String email, password, deviceInformation;

  LogInCredentials({this.email, this.password, this.deviceInformation});

  factory LogInCredentials.fromJson(Map<String, dynamic> json) => _$LogInCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$LogInCredentialsToJson(this);
}