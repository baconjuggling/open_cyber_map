import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_map_cubit.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_state.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_cubit.dart';
import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_state.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:cyber_map/core/presentation/widgets/components/sliders/app_slider.dart';
import 'package:cyber_map/core/presentation/widgets/components/text_fields/app_text_field.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/osm_object_button.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/tag_key_expansion_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class KeyMenu extends StatefulWidget {
  const KeyMenu({
    super.key,
    required this.popupController,
    required this.animatedMapController,
  });

  final PopupController popupController;
  final AnimatedMapController animatedMapController;

  @override
  State<KeyMenu> createState() => _KeyMenuState();
}

class _KeyMenuState extends State<KeyMenu> {
  List<OSMObject> searchedObjects = [];
  final textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmojiTagMapCubit, EmojiTagState>(
      builder: (context, state) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppContainer(
                child: BlocBuilder<OsmDataCubit, OsmDataCubitState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text(
                          'POI Radius: ${state is OsmDataCubitLoaded ? state.radius.toInt() : 10}',
                        ),
                        AppSlider(
                          value: state is OsmDataCubitLoaded
                              ? state.radius.toInt()
                              : 10,
                          min: 1,
                          max: 50,
                          onChanged: (value) {},
                          onRelease: (value) {
                            context.read<OsmDataCubit>().setRadius(
                                  value.toDouble(),
                                );
                          },
                        ),
                        AppRoundedButton(
                          enabled: state is OsmDataCubitLoaded,
                          borderColor: state is OsmDataCubitSyncing ||
                                  state is OsmDataCubitLoading
                              ? AppColors.grey
                              : AppColors.primaryAccent,
                          label: "fetch data",
                          onTap: () {
                            context.read<OsmDataCubit>().fetchOSMObjects();
                          },
                        ),
                        if (state is OsmDataCubitSyncing) ...[
                          CircularProgressIndicator(
                            value: state.progress,
                          ),
                          Text(state.message),
                        ],
                        if (state is OsmDataCubitLoaded) ...[
                          AppTextField(
                            controller: textEditingController,
                            hintText: 'Search',
                            onChanged: (value) async {
                              searchedObjects = await context
                                  .read<OsmDataCubit>()
                                  .searchOSMObjects(value);
                              setState(() {});
                            },
                          ),
                          if (searchedObjects.isNotEmpty &&
                              searchedObjects.length < 100) ...[
                            for (final osmObject in searchedObjects)
                              BlocBuilder<RoutePlannerCubit, RoutePlannerState>(
                                builder: (context, state) {
                                  return OsmObjectButton(
                                    osmObject: osmObject,
                                    onSelected: (osmObject) {
                                      if (context.read<OsmDataCubit>().state
                                          is OsmDataCubitLoaded) {
                                        widget.animatedMapController.animateTo(
                                          dest: (context
                                                  .read<OsmDataCubit>()
                                                  .state as OsmDataCubitLoaded)
                                              .getCenter(
                                            osmObject is Node
                                                ? OSMType.node
                                                : osmObject is Way
                                                    ? OSMType.way
                                                    : OSMType.relation,
                                            osmObject.id,
                                          ),
                                        );
                                      }
                                    },
                                    onMapIconPressed: () {
                                      if (state is RoutePlannerLoaded) {
                                        if (state.waypoints
                                            .contains(osmObject)) {
                                          context
                                              .read<RoutePlannerCubit>()
                                              .removeWaypoint(osmObject);
                                        } else {
                                          context
                                              .read<RoutePlannerCubit>()
                                              .addWaypoint(osmObject);
                                        }
                                      }
                                    },
                                    isInRoutePlanner:
                                        state is RoutePlannerLoaded &&
                                            state.waypoints.contains(osmObject),
                                  );
                                },
                              ),
                          ],
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
            for (final tagKey in state.emojiTagMap.keys)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TagKeyExpansionList(
                  popupController: widget.popupController,
                  animatedMapController: widget.animatedMapController,
                  onSelected: (OSMObject osmObject) {},
                  tagKey: tagKey,
                ),
              ),
          ],
        );
      },
    );
  }
}
