import 'dart:async';
import 'dart:io';

import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/data/repositories/file_picker_repository.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_state.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_state.dart';
import 'package:cyber_map/core/domain/models/marker/o_s_m_object_marker.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/instruction_marker_pop_up.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/compass_layer.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/custom_map_cluster_layer.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/map_user_position_accuracy_layer.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/menu_layer.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/navigation_layer.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/user_position_map_layer.dart';
import 'package:cyber_map/core/utils/extensions/string/to_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_mbtiles/vector_map_tiles_mbtiles.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, this.center});
  final LatLng? center;
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  late final _mapController = MapController();
  late final _animatedMapController =
      AnimatedMapController(vsync: this, mapController: _mapController);

  late PopupController popupController;

  late Widget Function(BuildContext context, Marker marker) popupBuilder;

  late PopupOptions popupOptions;

  @override
  void initState() {
    super.initState();

    popupController = PopupController();

    popupBuilder = (context, marker) {
      if (marker is OSMObjectMarker) {
        return MarkerPopup(
          marker: marker,
        );
      }

      if (marker is RoadInstructionMarker) {
        return InstructionMarkerPopUp(marker: marker);
      }
      throw Exception('Unknown marker type');
    };

    popupOptions = PopupOptions(
      markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
      popupController: popupController,
      popupAnimation: const PopupAnimation.fade(
        duration: Duration(milliseconds: 200),
      ),
      popupBuilder: popupBuilder,
    );
  }

  LatLng? mapPosition;
  double? mapZoom;
  double? mapRotation;
  MbTiles? mbtiles;
  bool isMapLocked = false;
  Future<MbTiles> initTileProvider() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/uk_latest.mbtiles';
    final file = File(filePath);

    if (!(await file.exists())) {
      try {
        final pickedFile = await FilePickerRepository().pickFile();
        if (pickedFile != null) {
          await pickedFile.copy(filePath);
        }
      } catch (e) {}
    }

    return MbTiles(
      mbtilesPath: filePath,
      gzip: true,
    );
  }

  @override
  void dispose() {
    if (mbtiles != null) {
      mbtiles!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserPositionCubit, UserPositionState>(
      listener: (context, state) {
        if (isMapLocked) {
          if (state is UserPositionLoaded) {
            _animatedMapController.mapController.move(
              LatLng(
                state.userPosition.latitude,
                state.userPosition.longitude,
              ),
              _animatedMapController.mapController.camera.zoom,
            );
            _animatedMapController.mapController
                .rotate(-state.userPosition.heading);
          }
        }
      },
      child: BlocSelector<MapThemeCubit, MapThemeCubitState, Color>(
        selector: (state) {
          return state is MapThemeCubitStateLoaded
              ? state.themeData['layers']
                  .firstWhere(
                    (element) => element['id'] == 'background',
                  )['paint']['background-color']
                  .toString()
                  .colorFromMapColorString()!
              : AppColors.black;
        },
        builder: (context, state) {
          return FlutterMap(
            options: MapOptions(
              backgroundColor: state,
              initialCenter: widget.center ??
                  (context.read<MapPositionCubit>().state
                          as MapPositionStateLoaded)
                      .position,
              initialZoom: (context.read<MapPositionCubit>().state
                      as MapPositionStateLoaded)
                  .zoom,
              initialRotation: (context.read<MapPositionCubit>().state
                      as MapPositionStateLoaded)
                  .rotation,
              maxZoom: 20,
              minZoom: 0,
              onMapEvent: (p0) {
                context.read<MapPositionCubit>().updateMapPosition(
                      p0.camera.center,
                      p0.camera.zoom,
                      p0.camera.rotation,
                    );
              },
            ),
            mapController: _animatedMapController.mapController,
            children: [
              BlocBuilder<MapThemeCubit, MapThemeCubitState>(
                builder: (context, mapThemeCubitState) {
                  if (mapThemeCubitState is MapThemeCubitStateLoaded) {
                    return FutureBuilder(
                      future: initTileProvider(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return VectorTileLayer(
                            concurrency: 8,
                            memoryTileCacheMaxSize: 1024 * 1024 * 99,
                            memoryTileDataCacheMaxSize: 99,
                            theme: mapThemeCubitState.theme,
                            sprites: mapThemeCubitState.spriteStyle,
                            layerMode: VectorTileLayerMode.vector,
                            tileProviders: TileProviders({
                              'openmaptiles': MbTilesVectorTileProvider(
                                mbtiles: snapshot.data!,
                              ),
                            }),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              CustomMapClusterLayer(
                mapController: _animatedMapController.mapController,
                popupController: popupController,
                popupOptions: popupOptions,
              ),
              CompassLayer(
                isMapLocked: isMapLocked,
                onTap: () {
                  setState(() {
                    isMapLocked = !isMapLocked;
                  });
                },
              ),
              const IgnorePointer(child: MapUserPositionAccuracyLayer()),
              NavigationLayer(
                animatedMapController: _animatedMapController,
                popupController: popupController,
                popupOptions: popupOptions,
              ),
              const IgnorePointer(child: UserPositionMapLayer()),
              SizedBox.expand(
                child: MenuLayer(
                  popupController: popupController,
                  animatedMapController: _animatedMapController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
