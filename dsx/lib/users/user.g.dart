// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      password: json['password'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'password': instance.password,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName
    };

LogInCredentials _$LogInCredentialsFromJson(Map<String, dynamic> json) {
  return LogInCredentials(
      email: json['email'] as String,
      password: json['password'] as String,
      deviceInformation: json['deviceInformation'] as String);
}

Map<String, dynamic> _$LogInCredentialsToJson(LogInCredentials instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'deviceInformation': instance.deviceInformation
    };
