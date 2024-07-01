import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OSMParentView extends StatelessWidget {
  const OSMParentView({super.key, required this.parents});

  final Set<OSMObject> parents;
  @override
  Widget build(BuildContext context) {
    if (parents.isEmpty) {
      return const SizedBox();
    } else {
      return AppContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Parents:'),
              for (final parent in parents)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: AppRoundedButton(
                    label: '${parent.runtimeType} - ${parent.label}',
                    icon: parent.runtimeType == Node
                        ? SvgPicture.asset('assets/icons/Osm_element_node.svg')
                        : parent.runtimeType == Way && (parent as Way).isArea
                            ? SvgPicture.asset(
                                'assets/icons/Osm_element_area.svg',
                              )
                            : parent.runtimeType == Way
                                ? SvgPicture.asset(
                                    'assets/icons/Osm_element_way.svg',
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/Osm_element_relation.svg',
                                  ),
                    onTap: () {
                      navigatorKey.currentState?.pushNamed(
                        '/${parent.runtimeType.toString().toLowerCase()}/${parent.id}',
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }
}
