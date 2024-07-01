import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class AppColorIndicator extends StatelessWidget {
  const AppColorIndicator({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: AppColors.white,
        ),
      ),
    );
  }
}
