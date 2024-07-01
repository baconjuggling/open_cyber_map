import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({required this.title, required this.subtitle, super.key});

  final String title;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      borderRadius: 8,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Text(title, style: const TextStyle(fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              child: subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
