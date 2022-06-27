import 'package:flutter/material.dart';

class FlyPathProvider extends InheritedWidget {
  const FlyPathProvider({
    Key? key,
    required Widget child,
    required this.path,
  }) : super(key: key, child: child);
  final String path;

  Widget build(BuildContext context) => child;
  static FlyPathProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FlyPathProvider>();

  @override
  bool updateShouldNotify(covariant FlyPathProvider oldWidget) =>
      oldWidget.path != path;
}
