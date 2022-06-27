import 'package:flutter/material.dart';

class FlyRouteBuilder {
  FlyRouteBuilder({
    required this.builder,
    this.maintainState = true,
    this.onBeforeEnter,
  });

  final Widget Function(BuildContext context, Map<String, String> args) builder;

  final bool Function(String newRoute)? onBeforeEnter;

  final bool maintainState;
}

extension FlyRouteExtensions on Widget {
  FlyRouteBuilder buildStackRoute({
    bool maintainState = true,
    bool Function(String newRoute)? onBeforeEnter,
  }) =>
      FlyRouteBuilder(
        builder: (_, __) => this,
        onBeforeEnter: onBeforeEnter,
        maintainState: maintainState,
      );
}
class name extends StatefulWidget {
  name({Key? key}) : super(key: key);

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}