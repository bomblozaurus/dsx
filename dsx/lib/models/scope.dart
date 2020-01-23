enum Scope { DORMITORY, STUDENT, OTHER }

extension ScopeExtension on Scope {
  String get name => this.toString().split('.').last;
}
