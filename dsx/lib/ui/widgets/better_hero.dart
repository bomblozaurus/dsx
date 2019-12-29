import "package:flutter/material.dart";

class MaterialHero extends StatelessWidget {
  final Widget child;
  final String tag;

  const MaterialHero({Key key, this.tag, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Hero(
          tag: this.tag,
          child: this.child,
        ));
  }
}
