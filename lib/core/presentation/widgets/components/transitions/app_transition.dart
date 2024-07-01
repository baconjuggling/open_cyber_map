import 'package:flutter/widgets.dart';

class AppTransition extends StatelessWidget {
  const AppTransition({
    required this.child,
    required this.animation,
    super.key,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.25,
          end: 1,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
