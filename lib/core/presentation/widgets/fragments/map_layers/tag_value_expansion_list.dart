import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_map_cubit.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_state.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_state.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_cubit.dart';
import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_state.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/expansion_app_container.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/o_s_m_object_marker_builder.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/osm_object_button.dart';
import 'package:cyber_map/core/utils/extensions/string/tag_format_to_title_case.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class TagValueExpansionList extends StatelessWidget {
  const TagValueExpansionList({
    required this.tagKey,
    required this.tagValue,
    required this.popupController,
    required this.animatedMapController,
    required this.onSelected,
  });
  final String tagKey;
  final String tagValue;
  final PopupController popupController;
  final AnimatedMapController animatedMapController;
  final Function(OSMObject) onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        popupController.hideAllPopups();

        context.read<EmojiTagMapCubit>().toggleVisibility(
              tagKey: tagKey,
              tagValue: tagValue,
            );

        print(
          '${context.read<EmojiTagMapCubit>().state.emojiTagMap}',
        );
      },
      child: BlocBuilder<EmojiTagMapCubit, EmojiTagState>(
        builder: (context, emojiTagState) {
          return BlocBuilder<OsmDataCubit, OsmDataCubitState>(
            builder: (context, osmDataState) {
              return ExpansionAppContainer(
                subtitle: osmDataState is OsmDataCubitLoaded &&
                        osmDataState.tagMap.containsKey(
                          tagKey,
                        ) &&
                        osmDataState.tagMap[tagKey]!.containsKey(
                          tagValue,
                        )
                    ? osmDataState.tagMap[tagKey]![tagValue]!.length.toString()
                    : '0',
                title: emojiTagState.emojiTagMap[tagKey]![tagValue]['emoji']
                        .toString() +
                    tagValue.tagFormatToTitleCase,
                borderColor: emojiTagState.emojiTagMap[tagKey]![tagValue]
                            ['visible'] ==
                        true
                    ? AppColors.primaryAccent
                    : AppColors.secondaryAccent,
                backgroundColor: emojiTagState.emojiTagMap[tagKey]![tagValue]
                        ['visible'] as bool
                    ? AppColors.transparentPrimaryAccent
                    : AppColors.secondaryAccent.withOpacity(0.25),
                child: SizedBox(
                  height: osmDataState is OsmDataCubitLoaded &&
                          osmDataState.tagMap[tagKey] != null &&
                          osmDataState.tagMap[tagKey]![tagValue] != null
                      ? (osmDataState.tagMap[tagKey]![tagValue]!.length * 48) +
                          64
                      : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (osmDataState is OsmDataCubitLoaded &&
                          osmDataState.tagMap.containsKey(
                            tagKey,
                          ) &&
                          osmDataState.tagMap[tagKey]!.containsKey(
                            tagValue,
                          )) ...[
                        for (final OSMObject osmObject
                            in osmDataState.tagMap[tagKey]![tagValue]!) ...[
                          BlocBuilder<RoutePlannerCubit, RoutePlannerState>(
                            builder: (context, state) {
                              return OsmObjectButton(
                                isInRoutePlanner: state is RoutePlannerLoaded &&
                                    state.waypoints.contains(osmObject),
                                osmObject: osmObject,
                                onMapIconPressed: () {
                                  if (state is RoutePlannerLoaded &&
                                      state.waypoints.contains(osmObject)) {
                                    context
                                        .read<RoutePlannerCubit>()
                                        .removeWaypoint(
                                          osmObject,
                                        );
                                  } else {
                                    context
                                        .read<RoutePlannerCubit>()
                                        .addWaypoint(
                                          osmObject,
                                        );
                                  }
                                },
                                borderColor:
                                    emojiTagState.emojiTagMap[tagKey]![tagValue]
                                                ['visible'] ==
                                            true
                                        ? AppColors.primaryAccent
                                        : AppColors.secondaryAccent,
                                onSelected: (osmObject) {
                                  if (emojiTagState
                                              .emojiTagMap[tagKey]![tagValue]
                                          ['visible'] ==
                                      false) {
                                    context
                                        .read<EmojiTagMapCubit>()
                                        .toggleVisibility(
                                          tagKey: tagKey,
                                          tagValue: tagValue,
                                        );
                                  }

                                  animatedMapController.animateTo(
                                    dest: osmObject is Node
                                        ? LatLng(
                                            osmObject.latitude,
                                            osmObject.longitude,
                                          )
                                        : osmDataState.getCenter(
                                            osmObject is Node
                                                ? OSMType.node
                                                : osmObject is Way
                                                    ? OSMType.way
                                                    : OSMType.relation,
                                            osmObject.id,
                                          ),
                                    zoom: (context
                                            .read<MapPositionCubit>()
                                            .state as MapPositionStateLoaded)
                                        .zoom,
                                  );

                                  final Marker preLoadMarker =
                                      OSMObjectMarkerBuilder
                                          .buildOSMObjectMarker(
                                    osmObject: osmObject,
                                    point: osmDataState.getCenter(
                                      osmObject is Node
                                          ? OSMType.node
                                          : osmObject is Way
                                              ? OSMType.way
                                              : OSMType.relation,
                                      osmObject.id,
                                    ),
                                    emoji: emojiTagState
                                            .emojiTagMap[tagKey]![tagValue]
                                        ['emoji'] as String,
                                  );

                                  popupController.hidePopupsWhere(
                                    (marker) => marker != preLoadMarker,
                                  );

                                  popupController.togglePopup(
                                    preLoadMarker,
                                  );

                                  onSelected(
                                    osmObject,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
