import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_cubit.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_route_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_cubit.dart';
import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_state.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_state.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_check_box.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/expansion_app_container.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/navigation_layer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class RoutePlannerMenu extends StatelessWidget {
  const RoutePlannerMenu({
    super.key,
    required this.animatedMapController,
  });
  final AnimatedMapController animatedMapController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationRouteCubit, NavigationRouteCubitState>(
      builder: (context, navigationRouteState) {
        return BlocBuilder<RoutePlannerCubit, RoutePlannerState>(
          builder: (context, routePlannerState) {
            return ListView(
              children: [
                ExpansionAppContainer(
                  title: 'Route Planner',
                  subtitle: 'Plan your route',
                  child: Center(
                    child: Column(
                      children: [
                        ReorderableList(
                          itemCount: routePlannerState is RoutePlannerLoaded
                              ? routePlannerState.waypoints.length
                              : 0,
                          onReorder: (int oldIndex, int newIndex) {
                            context.read<RoutePlannerCubit>().reorderWaypoints(
                                  oldIndex,
                                  newIndex,
                                );
                          },
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return BlocBuilder<OsmDataCubit, OsmDataCubitState>(
                              key: ValueKey(
                                routePlannerState is RoutePlannerLoaded
                                    ? routePlannerState.waypoints[index].id
                                    : null,
                              ),
                              builder: (context, state) {
                                if (routePlannerState is RoutePlannerLoaded) {
                                  final OSMObject waypoint =
                                      routePlannerState.waypoints[index];
                                  return ReorderableDragStartListener(
                                    index: index,
                                    child: GestureDetector(
                                      child: SizedBox(
                                        height: 30,
                                        child: AppContainer(
                                          child: Text(waypoint.label),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          },
                        ),
                        if (routePlannerState is RoutePlannerLoaded) ...[
                          Row(
                            children: [
                              const Text('Round Trip?'),
                              AppCheckBox(
                                enabled: routePlannerState.isRoundTrip,
                                onTap: () {
                                  context
                                      .read<RoutePlannerCubit>()
                                      .toggleRoundTrip();
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Traveling Salesman?'),
                              AppCheckBox(
                                enabled: routePlannerState.travelingSalesman,
                                onTap: () {
                                  context
                                      .read<RoutePlannerCubit>()
                                      .toggleTravelingSalesman();
                                },
                              ),
                            ],
                          ),
                          AppRoundedButton(
                            label: 'Get Route',
                            onTap: () {
                              final OsmDataCubitLoaded osmDataCubitLoaded =
                                  context.read<OsmDataCubit>().state
                                      as OsmDataCubitLoaded;
                              context.read<NavigationRouteCubit>().getRoute(
                                roundTrip: routePlannerState.isRoundTrip,
                                travelingSalesman:
                                    routePlannerState.travelingSalesman,
                                selectedLocations: [
                                  (context.read<UserPositionCubit>().state
                                          as UserPositionLoaded)
                                      .userPosition
                                      .getLatLng(),
                                  ...routePlannerState.waypoints.map(
                                    (e) => osmDataCubitLoaded.getCenter(
                                      e is Node
                                          ? OSMType.node
                                          : e is Way
                                              ? OSMType.way
                                              : OSMType.relation,
                                      e.id,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          AppRoundedButton(
                            label: 'Clear Route',
                            onTap: () {
                              context
                                  .read<RoutePlannerCubit>()
                                  .clearWaypoints();

                              context.read<NavigationRouteCubit>().clearRoute();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                ExpansionAppContainer(
                  title: 'Navigation Instructions',
                  subtitle: 'Instructions for navigation',
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        AppRoundedButton(
                          label: "print next instruction",
                          onTap: () {
                            if (navigationRouteState
                                is NavigationRouteCubitStateLoaded) {
                              context
                                  .read<NavigationRouteCubit>()
                                  .nextInstruction();
                            }
                          },
                        ),
                        if (navigationRouteState
                            is NavigationRouteCubitStateLoaded) ...[
                          Center(
                            child: Text(
                              'Distance: ${navigationRouteState.route.totalDistance}',
                            ),
                          ),
                          for (final leg
                              in navigationRouteState.route.legs) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                              child: AppContainer(
                                boxShadows: leg ==
                                        navigationRouteState.currentLeg
                                    ? [
                                        BoxShadow(
                                          color: AppColors.colors[
                                              navigationRouteState.route.legs
                                                      .indexOf(leg) %
                                                  AppColors.colors.length],
                                          blurRadius: 8,
                                        ),
                                      ]
                                    : [],
                                borderColor: AppColors.colors[
                                    navigationRouteState.route.legs
                                            .indexOf(leg) %
                                        AppColors.colors.length],
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    16,
                                    8,
                                    16,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Instruction Group'),
                                      for (final instruction
                                          in leg.instructions) ...[
                                        AppContainer(
                                          borderColor: AppColors.colors[
                                              navigationRouteState.route.legs
                                                      .indexOf(
                                                    leg,
                                                  ) %
                                                  AppColors.colors.length],
                                          boxShadows: navigationRouteState
                                                      .currentInstruction ==
                                                  instruction
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.colors[
                                                        navigationRouteState
                                                                .route.legs
                                                                .indexOf(leg) %
                                                            AppColors
                                                                .colors.length],
                                                    blurRadius: 8,
                                                  ),
                                                ]
                                              : [],
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              8,
                                              16,
                                              8,
                                              16,
                                            ),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    print(
                                                      'instruction: ${instruction.instruction}',
                                                    );
                                                    print(
                                                      'location: ${instruction.location}',
                                                    );
                                                    animatedMapController
                                                        .animateTo(
                                                      dest:
                                                          instruction.location,
                                                    );
                                                  },
                                                  child: Icon(
                                                    getIconBasedOnInstruction(
                                                      instruction.instruction,
                                                    ),
                                                    size: 60,
                                                    color: AppColors.colors[
                                                        navigationRouteState
                                                                .route.legs
                                                                .indexOf(
                                                              leg,
                                                            ) %
                                                            AppColors
                                                                .colors.length],
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(
                                                        'instruction: ${instruction.instruction}',
                                                      );
                                                      print(
                                                        'location: ${instruction.location}',
                                                      );
                                                      animatedMapController
                                                          .animateTo(
                                                        dest: instruction
                                                            .location,
                                                      );
                                                    },
                                                    child: Text(
                                                      instruction.instruction,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                        if (navigationRouteState
                            is NavigationRouteCubitStateInitial) ...[
                          const Center(
                            child: Text('Select a destination'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
