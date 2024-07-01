import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/searchable_list_widget.dart';
import 'package:cyber_map/core/utils/route_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagsValueListPage extends StatelessWidget {
  const TagsValueListPage({
    super.key,
    required this.tagKey,
  });
  final String tagKey;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OsmDataCubit, OsmDataCubitState>(
      builder: (context, state) {
        return SearchableListWidget<String>(
          title: 'Values for $tagKey',
          items: (state is OsmDataCubitLoaded)
              ? state.tagMap[tagKey]!.keys.toList()
              : [],
          getLabel: (tagValue) => tagValue,
          getRoute: (tagValue) {
            return '/tag/${RouteUtil.formatRouteName(tagKey)}/${RouteUtil.formatRouteName(tagValue)}';
          },
          filterItem: (tagValue, searchText) =>
              tagValue.toLowerCase().contains(searchText.toLowerCase()),
        );
      },
    );
  }
}
