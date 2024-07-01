import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_map_cubit.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_state.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/expansion_app_container.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/tag_value_expansion_list.dart';
import 'package:cyber_map/core/utils/extensions/string/tag_format_to_title_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class TagKeyExpansionList extends StatelessWidget {
  const TagKeyExpansionList({
    super.key,
    required this.tagKey,
    required this.popupController,
    required this.animatedMapController,
    required this.onSelected,
  });

  final String tagKey;
  final PopupController popupController;
  final AnimatedMapController animatedMapController;
  final void Function(OSMObject)? onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        popupController.hideAllPopups();
        context.read<EmojiTagMapCubit>().toggleVisibility(
              tagKey: tagKey,
            );
      },
      child: BlocBuilder<EmojiTagMapCubit, EmojiTagState>(
        builder: (context, state) {
          return BlocBuilder<OsmDataCubit, OsmDataCubitState>(
            builder: (context, osmDataState) {
              return ExpansionAppContainer(
                borderColor: state.emojiTagMap[tagKey]!.values.every(
                  (element) => element['visible'] == true,
                )
                    ? AppColors.primaryAccent
                    : state.emojiTagMap[tagKey]!.values.every(
                        (element) => element['visible'] == false,
                      )
                        ? AppColors.secondaryAccent
                        : AppColors.amber,
                backgroundColor: state.emojiTagMap[tagKey]!.values.every(
                  (element) => element['visible'] == true,
                )
                    ? AppColors.transparentPrimaryAccent
                    : state.emojiTagMap[tagKey]!.values.every(
                        (element) => element['visible'] == false,
                      )
                        ? AppColors.secondaryAccent.withOpacity(0.25)
                        : AppColors.amber.withOpacity(0.25),
                title: tagKey.tagFormatToTitleCase,
                subtitle: osmDataState is OsmDataCubitLoaded &&
                        osmDataState.tagMap.containsKey(tagKey)
                    ? osmDataState.tagMap[tagKey]!.values
                        .fold<int>(
                          0,
                          (previousValue, element) =>
                              previousValue + element.length,
                        )
                        .toString()
                    : '0',
                child: Column(
                  children: [
                    for (final tagValue in state.emojiTagMap[tagKey]!.keys)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TagValueExpansionList(
                          tagKey: tagKey,
                          tagValue: tagValue,
                          popupController: popupController,
                          animatedMapController: animatedMapController,
                          onSelected: onSelected!,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
