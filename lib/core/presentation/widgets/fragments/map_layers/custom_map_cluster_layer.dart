import 'dart:math';

import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_map_cubit.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_state.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_cubit.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_route_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_state.dart';
import 'package:cyber_map/core/domain/models/marker/o_s_m_object_marker.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/o_s_m_object_marker_builder.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/pretty_tag_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class CustomMapClusterLayer extends StatelessWidget {
  const CustomMapClusterLayer({
    required this.mapController,
    required this.popupController,
    required this.popupOptions,
  });
  final MapController mapController;
  final PopupController popupController;
  final PopupOptions popupOptions;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OsmDataCubit, OsmDataCubitState>(
      builder: (context, state) {
        return BlocBuilder<EmojiTagMapCubit, EmojiTagState>(
          builder: (context, emojiTagMapState) {
            return PopupScope(
              popupController: popupController,
              child: MarkerClusterLayer(
                mapController: mapController,
                mapCamera: MapCamera.of(context),
                options: MarkerClusterLayerOptions(
                  onMarkerTap: (marker) {
                    if (context.read<NavigationRouteCubit>().state
                            is NavigationRouteCubitStateInitial ||
                        (context.read<NavigationRouteCubit>().state
                                is NavigationRouteCubitStateLoaded &&
                            (context.read<NavigationRouteCubit>().state
                                    as NavigationRouteCubitStateLoaded)
                                .route
                                .polyline
                                .isEmpty)) {
                      context.read<NavigationRouteCubit>().getRoute(
                            travelingSalesman: false,
                            roundTrip: false,
                            selectedLocations: [
                              if (context.read<UserPositionCubit>().state
                                  is UserPositionLoaded)
                                (context.read<UserPositionCubit>().state
                                        as UserPositionLoaded)
                                    .userPosition
                                    .getLatLng(),
                              marker.point,
                            ].whereType<LatLng>().toList(),
                          );
                    }
                  },
                  size: const Size(40, 40),
                  popupOptions: popupOptions,
                  maxClusterRadius: 40,
                  showPolygon: false,
                  maxZoom: 20,
                  onMarkersClustered: (markers) {},
                  markers: [
                    if (state is OsmDataCubitLoaded) ...[
                      for (final String key
                          in emojiTagMapState.emojiTagMap.keys)
                        if (emojiTagMapState.emojiTagMap[key] != null)
                          for (final String value
                              in emojiTagMapState.emojiTagMap[key]!.keys)
                            if (state.tagMap[key] != null &&
                                state.tagMap[key]!.containsKey(value) &&
                                emojiTagMapState.emojiTagMap[key]![value]
                                        ['visible'] ==
                                    true)
                              for (final OSMObject object
                                  in state.tagMap[key]![value]!) ...[
                                OSMObjectMarkerBuilder.buildOSMObjectMarker(
                                  osmObject: object,
                                  emoji:
                                      emojiTagMapState.emojiTagMap[key]![value]
                                          ['emoji'] as String,
                                  point: state.getCenter(
                                    object is Node
                                        ? OSMType.node
                                        : object is Way
                                            ? OSMType.way
                                            : OSMType.relation,
                                    object.id,
                                  ),
                                ),
                              ],
                    ],
                  ],
                  builder: (context, markers) {
                    return ClusterGridWidget(
                      markers: markers,
                    );
                  },
                  rotate: true,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ClusterGridWidget extends StatelessWidget {
  const ClusterGridWidget({
    super.key,
    required this.markers,
    this.size = 60,
  });

  final List<Marker> markers;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: IgnorePointer(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: markers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: calculateColumns(markers.length),
            ),
            itemBuilder: (BuildContext context, int index) {
              return AspectRatio(
                aspectRatio: 1,
                child: FittedBox(child: markers[index].child),
              );
            },
          ),
        ),
      ),
    );
  }

  int calculateColumns(int count) {
    return sqrt(count).ceil();
  }
}

class MarkerPopup extends StatelessWidget {
  const MarkerPopup({
    required this.marker,
  });
  final OSMObjectMarker marker;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: SizedBox(
        height: 400,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                marker.object.label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 400,
                    child: PrettyTagDisplay(
                      data: marker.object.tags,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
