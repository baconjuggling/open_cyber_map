import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/app_list_tile.dart';
import 'package:flutter/widgets.dart';

class PrettyTagDisplay extends StatelessWidget {
  const PrettyTagDisplay({required this.data, super.key});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text('No Tags');
    }
    return AppContainer(
      backgroundColor: AppColors.transparentPrimaryAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final tag in data.entries)
            Padding(
              padding: const EdgeInsets.all(4),
              child: AppListTile(
                title: tag.key,
                // ignore: avoid_dynamic_calls
                subtitle: tag.value.runtimeType == String
                    ? Text(
                        tag.value.toString(),
                        style: const TextStyle(fontSize: 12),
                      )
                    : PrettyTagDisplay(
                        data: tag.value as Map<String, dynamic>,
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
