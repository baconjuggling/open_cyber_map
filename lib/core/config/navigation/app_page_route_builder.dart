import 'package:cyber_map/core/presentation/widgets/components/transitions/app_transition.dart';
import 'package:flutter/widgets.dart';

class AppPageRouteBuilder extends PageRouteBuilder<dynamic> {
  AppPageRouteBuilder({
    required String routeName,
    required super.pageBuilder,
  }) : super(
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              AppTransition(animation: animation, child: child),
          settings: RouteSettings(name: routeName),
        );
}
