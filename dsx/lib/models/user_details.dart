import 'package:dsx/models/scope.dart';
import 'package:dsx/models/user_roles.dart';

class UserDetails {
  final List<UserRole> roles;
  final String name;
  final String mail;
  final Scope scope;

  UserDetails({this.roles, this.name, this.mail, this.scope});

  bool isUser() {
    return roles.contains(UserRole.USER);
  }

  bool isKeyholder() {
    return roles.contains(UserRole.KEYHOLDER);
  }

  bool isDormitory() {
    return Scope.DORMITORY == scope;
  }

  bool isStudent() {
    return (Scope.STUDENT == scope || Scope.DORMITORY == scope);
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    _getRoles() {
      return (json['role'] as String)
          .split(',')
          .map((roleString) => UserRole.values.firstWhere((role) =>
              role.toString() == 'UserRole.${roleString.toUpperCase()}'))
          .toList();
    }

    _getScope() {
      String scopeString = json['scope'] as String;
      return Scope.values.firstWhere(
          (scope) => scope.toString() == 'Scope.${scopeString.toUpperCase()}');
    }

    _getName() {
      return (json['name'] as String);
    }

    _getMail() {
      return (json['sub'] as String);
    }

    return UserDetails(
        roles: _getRoles(),
        name: _getName(),
        mail: _getMail(),
        scope: _getScope());
  }
}
