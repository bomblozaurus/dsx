enum UserRole { USER, KEYHOLDER }

extension UserRolesExtension on UserRole {
  String get role => this.toString().split('.').last;
}
