import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';

class MissingOSMObjectPage extends StatelessWidget {
  const MissingOSMObjectPage({super.key, required this.id, required this.type});

  final int id;
  final OSMType type;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        children: [
          AppContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'OSM $type with id $id not found',
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AppRoundedButton(
            label: 'Get Data',
            onTap: () {},
          ),
          AppRoundedButton(
            label: 'Back',
            onTap: () {
              navigatorKey.currentState?.pop();
            },
          ),
        ],
      ),
    );
  }
}
