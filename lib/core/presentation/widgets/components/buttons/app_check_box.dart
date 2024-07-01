import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/config/theme/app_icons.dart';
import 'package:flutter/material.dart';

class AppCheckBox extends StatelessWidget {
  const AppCheckBox({
    required this.enabled,
    required this.onTap,
  });

  final bool enabled;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryAccent : AppColors.transparent,
          border: Border.all(
            color: AppColors.primaryAccent,
          ),
        ),
        child: enabled
            ? const Icon(AppIcons.check, size: 16.0)
            : const Icon(
                AppIcons.close,
                size: 16.0,
                color: AppColors.primaryAccent,
              ),
      ),
    );
  }
}
