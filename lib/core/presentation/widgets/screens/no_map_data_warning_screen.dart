import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:flutter/widgets.dart';

class NoMapDataWarningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No Map Data Available',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
              ),
            ),
            const Text(
              'Please fetch map data from the server',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
              ),
            ),
            AppRoundedButton(
              label: 'Fetch Map Data',
              onTap: () {
                navigatorKey.currentState?.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
