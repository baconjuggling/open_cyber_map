import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/relation/relation.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/osm_child_view.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/pretty_tag_display.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/route_display.dart';
import 'package:flutter/widgets.dart';

class OSMObjectPage extends StatelessWidget {
  const OSMObjectPage({required this.osmObject, super.key});
  final OSMObject osmObject;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: Expanded(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (osmObject is Node) ...[
                  const Text('Node Page'),
                  Text('Node ID: ${osmObject.id}'),
                  Text(
                    'Node Location: ${(osmObject as Node).latitude}, ${(osmObject as Node).longitude}',
                  ),
                ],
                if (osmObject is Way) ...[
                  const Text('Way Page'),
                  Text('Way ID: ${osmObject.id}'),
                  Text('Way Length: ${(osmObject as Way).nodes.length}'),
                ],
                if (osmObject is Relation) ...[
                  const Text('Relation Page'),
                  Text('Relation ID: ${osmObject.id}'),
                  Text(
                    'Relation Length: ${(osmObject as Relation).members.length}',
                  ),
                ],
                AppRoundedButton(
                  label: 'Display on Map',
                  onTap: () {
                    {
                      if (osmObject is Node?) {
                        navigatorKey.currentState?.pushNamed(
                          '/map/${(osmObject as Node).latitude}/${(osmObject as Node).longitude}',
                        );
                      }
                    }
                  },
                ),
                AppRoundedButton(
                  label: 'Back',
                  onTap: () {
                    navigatorKey.currentState?.pop();
                  },
                ),
                Wrap(
                  children: [
                    OSMChildView(osmObject: osmObject),
                    PrettyTagDisplay(data: osmObject.tags),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageTemplate extends StatelessWidget {
  const PageTemplate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: RouteDisplay(),
        ),
        child,
      ],
    );
  }
}
