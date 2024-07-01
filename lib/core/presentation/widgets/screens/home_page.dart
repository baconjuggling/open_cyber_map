import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const AppContainer(
              borderColor: AppColors.white,
              backgroundColor: AppColors.black,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('CYBER MAP', style: TextStyle(fontSize: 50)),
              ),
            ),
            AppContainer(
              backgroundColor: AppColors.transparentPrimaryAccent,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppRoundedButton(
                      label: 'Map',
                      onTap: () {
                        navigatorKey.currentState?.pushNamed('/map');
                      },
                    ),
                    const SizedBox(height: 8),
                    AppRoundedButton(
                      label: 'Tags List',
                      onTap: () {
                        navigatorKey.currentState?.pushNamed('/tag');
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
