import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/relation/relation.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OSMChildView extends StatelessWidget {
  const OSMChildView({super.key, required this.osmObject});

  final OSMObject osmObject;
  @override
  Widget build(BuildContext context) {
    switch (osmObject.runtimeType) {
      case Node _:
        return const SizedBox();
      case Way _:
        return AppContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Way Nodes:'),
                AppRoundedButton(
                  label: 'Request Missing Data',
                  borderColor: AppColors.secondaryAccent,
                  onTap: () {},
                ),
                for (final node in (osmObject as Way).nodes)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: AppRoundedButton(
                      label: '$node',
                      onTap: () {
                        navigatorKey.currentState?.pushNamed('/node/$node');
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/Osm_element_node.svg',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      case Relation _:
        return AppContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Relation Members:'),
                for (final member in (osmObject as Relation).members)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: AppRoundedButton(
                      label: '${member.type} - ${member.ref} - ${member.role}',
                      onTap: () {
                        navigatorKey.currentState?.pushNamed(
                          '/${member.type}/${member.ref}',
                        );
                      },
                      icon: member.type == 'node'
                          ? SvgPicture.asset(
                              'assets/icons/Osm_element_node.svg',
                            )
                          : member.type == 'way' &&
                                  osmObject.tags.containsKey('area')
                              ? SvgPicture.asset(
                                  'assets/icons/Osm_element_area.svg',
                                )
                              : member.type == 'way'
                                  ? SvgPicture.asset(
                                      'assets/icons/Osm_element_way.svg',
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/Osm_element_relation.svg',
                                    ),
                    ),
                  ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
