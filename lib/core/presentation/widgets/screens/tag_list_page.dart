import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/searchable_list_widget.dart';
import 'package:cyber_map/core/utils/route_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagListPage extends StatelessWidget {
  const TagListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OsmDataCubit, OsmDataCubitState>(
      builder: (context, state) {
        return SearchableListWidget<String>(
          title: 'Tag Key List',
          items:
              (state is OsmDataCubitLoaded) ? state.tagMap.keys.toList() : [],
          getLabel: (tagKey) => tagKey,
          getRoute: (tagKey) => '/tag/${RouteUtil.formatRouteName(tagKey)}',
          filterItem: (tagKey, searchText) =>
              tagKey.toLowerCase().contains(searchText.toLowerCase()),
        );
      },
    );
  }
}
