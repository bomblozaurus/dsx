import 'package:dsx/models/user_roles.dart';

class UserDetails {
  final List<UserRole> roles;
  final String name;
  final String mail;

  UserDetails({this.roles, this.name, this.mail});

  bool isUser() {
    return roles.contains(UserRole.USER);
  }

  bool isKeyholder() {
    return roles.contains(UserRole.KEYHOLDER);
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    _getRoles() {
      return (json['role'] as String)
          .split(',')
          .map((roleString) => UserRole.values.firstWhere((role) =>
              role.toString() == 'UserRole.${roleString.toUpperCase()}'))
          .toList();
    }

    _getName() {
      return (json['name'] as String);
    }

    _getMail() {
      return (json['sub'] as String);
    }

    return UserDetails(roles: _getRoles(), name: _getName(), mail: _getMail());
  }
}
