import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/searchable_list_widget.dart';
import 'package:flutter/widgets.dart';

class OSMObjectListPage extends StatelessWidget {
  const OSMObjectListPage({
    required this.osmObjects,
    super.key,
    required this.title,
  });
  final Set<OSMObject> osmObjects;
  final String title;

  @override
  Widget build(BuildContext context) {
    final List<OSMObject> list = osmObjects.toList();

    return SearchableListWidget(
      title: title,
      items: list,
      getLabel: (osmObject) => osmObject.tags.containsKey('name')
          ? osmObject.tags['name'].toString()
          : osmObject.id.toString(),
      getRoute: (osmObject) => osmObject.route,
      filterItem: (osmObject, searchText) => osmObject.tags.containsKey('name')
          ? osmObject.tags['name']
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase())
          : osmObject.id.toString().contains(searchText.toLowerCase()),
    );
  }
}
