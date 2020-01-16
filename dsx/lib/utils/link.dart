class Link {
  final String rel;
  final String href;

  Link({this.rel, this.href});

  static Link fromJson(Map<String, dynamic> json) => Link(
        rel: json['rel'] as String,
        href: json['href'] as String,
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'rel': this.rel, 'href': this.href};
}
