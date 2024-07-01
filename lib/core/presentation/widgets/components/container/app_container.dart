import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    required this.child,
    super.key,
    this.borderRadius = 36,
    this.borderColor = AppColors.primaryAccent,
    this.backgroundColor = AppColors.transparentBlack,
    this.boxShadows,
  });

  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadows;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: boxShadows,
      ),
      child: child,
    );
  }
}
