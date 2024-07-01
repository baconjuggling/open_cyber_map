import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_state.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_cubit.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_route_cubit_state.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/custom_map_cluster_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

List<Color> colors = [
  const Color(0xFF00FF00),
  const Color(0xFFFF0000),
  const Color(0xFF00FFFF),
  const Color(0xFFFF00FF),
  const Color(0xFFFFFF00),
];

class NavigationLayer extends StatelessWidget {
  NavigationLayer({
    super.key,
    required this.animatedMapController,
    required this.popupController,
    required this.popupOptions,
  });

  final AnimatedMapController animatedMapController;
  final PopupController popupController;
  final PopupOptions popupOptions;

  double activeLegOpacity = 1;
  double inactiveLegOpacity = 0.4;

  double activeInstructionOpacity = 1;
  double semiActiveInstruction = 0.8;
  double inactiveInstructionOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationRouteCubit, NavigationRouteCubitState>(
      builder: (context, state) {
        final List<LatLng> destinations = [];
        final List<Polyline> polylines = [];
        final List<RoadInstructionMarker> markers = [];
        if (state is NavigationRouteCubitStateLoaded) {
          for (final leg in state.route.legs) {
            if (state.currentLeg == leg) {
              for (final instruction in leg.instructions) {
                markers.add(
                  RoadInstructionMarker(
                    width: state.currentInstruction == instruction ? 50 : 30,
                    height: state.currentInstruction == instruction ? 50 : 30,
                    instruction: instruction,
                    point: instruction.location,
                    child: AppContainer(
                      borderColor: colors[
                              (state.route.legs.indexOf(leg)) % colors.length]
                          .withOpacity(
                        state.currentInstruction == instruction
                            ? activeInstructionOpacity
                            : state.currentLeg == leg
                                ? semiActiveInstruction
                                : inactiveInstructionOpacity,
                      ),
                      child: Icon(
                        getIconBasedOnInstruction(
                          instruction.instruction,
                        ),
                        color: colors[
                                (state.route.legs.indexOf(leg)) % colors.length]
                            .withOpacity(
                          state.currentInstruction == instruction
                              ? activeInstructionOpacity
                              : state.currentLeg == leg
                                  ? semiActiveInstruction
                                  : inactiveInstructionOpacity,
                        ),
                        size: state.currentInstruction == instruction ? 50 : 30,
                      ),
                    ),
                  ),
                );
                if (instruction.instruction.toLowerCase().contains('arrive')) {
                  destinations.add(instruction.location);
                }
              }
            }
          }
        }

        if (state is NavigationRouteCubitStateLoaded) {
          for (final leg in state.route.legs) {
            polylines.add(
              Polyline(
                isDotted: true,
                color: AppColors.transparentBlack.withOpacity(
                  state.currentLeg == leg ? 1 : 0.25,
                ),
                borderColor:
                    colors[(state.route.legs.indexOf(leg)) % colors.length]
                        .withOpacity(
                  state.currentLeg == leg
                      ? activeLegOpacity
                      : inactiveLegOpacity,
                ),
                borderStrokeWidth: 3,
                points: leg.polyline,
                strokeWidth: 10,
              ),
            );
          }
        }
        if (state is NavigationRouteCubitStateLoaded) {
          return PopupScope(
            child: Stack(
              children: [
                SizedBox.expand(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${state.route.totalDistanceString}, ${state.route.totalDurationString}',
                              style: const TextStyle(
                                color: AppColors.primaryAccent,
                                fontSize: 20,
                              ),
                            ),
                            ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<NavigationRouteCubit>()
                                          .previousInstruction();
                                      animatedMapController.animateTo(
                                        dest:
                                            state.previousInstruction!.location,
                                        zoom: animatedMapController
                                            .mapController.camera.zoom,
                                      );
                                    },
                                    child: const Text(
                                      'Previous',
                                      style: TextStyle(
                                        color: AppColors.primaryAccent,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    getIconBasedOnInstruction(
                                      state.currentInstruction.instruction,
                                    ),
                                    color: colors[(state.route.legs
                                                .indexOf(state.currentLeg)) %
                                            colors.length]
                                        .withOpacity(
                                      activeInstructionOpacity,
                                    ),
                                    size: 50,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<NavigationRouteCubit>()
                                          .nextInstruction();
                                      if (state.nextInstruction != null) {
                                        animatedMapController.animateTo(
                                          dest: state.nextInstruction!.location,
                                          zoom: animatedMapController
                                              .mapController.camera.zoom,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Next',
                                      style: TextStyle(
                                        color: AppColors.primaryAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                state.currentInstruction.instruction,
                                style: const TextStyle(
                                  color: AppColors.primaryAccent,
                                  fontSize: 20,
                                ),
                              ),
                              AppRoundedButton(
                                label: 'clear',
                                onTap: () {
                                  context
                                      .read<NavigationRouteCubit>()
                                      .clearRoute();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: PolylineLayer(
                    polylines: polylines,
                  ),
                ),
                MarkerClusterLayer(
                  mapController: animatedMapController.mapController,
                  mapCamera: MapCamera.of(context),
                  options: MarkerClusterLayerOptions(
                    onMarkerTap: (marker) {},
                    popupOptions: popupOptions,
                    maxClusterRadius: 30,
                    builder: (context, markers) =>
                        ClusterGridWidget(markers: markers, size: 30),
                    markers: markers,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

IconData getIconBasedOnInstruction(String instruction) {
  if (instruction.toLowerCase().contains('arrive')) {
    return Icons.flag;
  } else if (instruction.contains('Turn right')) {
    return Icons.turn_right;
  } else if (instruction.toLowerCase().contains('turn left')) {
    return Icons.turn_left;
  } else if (instruction.toLowerCase().contains('slight right')) {
    return Icons.turn_slight_right;
  } else if (instruction.toLowerCase().contains('slight left')) {
    return Icons.turn_slight_left;
  } else if (instruction.toLowerCase().contains('sharp right')) {
    return Icons.turn_sharp_right;
  } else if (instruction.toLowerCase().contains('sharp left')) {
    return Icons.turn_sharp_left;
  } else if (instruction.toLowerCase().contains('keep right')) {
    return Icons.fork_right;
  } else if (instruction.toLowerCase().contains('keep left')) {
    return Icons.fork_left;
  } else if (instruction.toLowerCase().contains('straight')) {
    return Icons.arrow_forward;
  } else if (instruction.toLowerCase().contains('roundabout')) {
    return Icons.rotate_right;
  } else if (instruction.toLowerCase().contains('continue')) {
    return Icons.arrow_upward;
  } else if (instruction.toLowerCase().contains('u-turn')) {
    return Icons.u_turn_left;
  } else {
    return Icons.location_on;
  }
}

abstract class PolylineDecoder {
  static List<LatLng> decode(String encodedPolyline) {
    final List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;
    while (index < encodedPolyline.length) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encodedPolyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encodedPolyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      points.add(
        LatLng(
          lat / 1E6,
          lng / 1E6,
        ),
      );
    }
    return points;
  }
}
