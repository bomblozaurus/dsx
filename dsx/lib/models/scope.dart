enum Scope { DORMITORY, STUDENT, OTHER }

extension ScopeExtension on Scope {
  String get scope => this.toString().split('.').last;
}
