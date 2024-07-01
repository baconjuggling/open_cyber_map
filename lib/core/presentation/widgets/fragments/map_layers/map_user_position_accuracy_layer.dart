import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapUserPositionAccuracyLayer extends StatefulWidget {
  const MapUserPositionAccuracyLayer({
    super.key,
  });

  @override
  _MapUserPositionAccuracyLayerState createState() =>
      _MapUserPositionAccuracyLayerState();
}

class _MapUserPositionAccuracyLayerState
    extends State<MapUserPositionAccuracyLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPositionCubit, UserPositionState>(
      builder: (context, state) {
        if (state is UserPositionLoaded) {
          return BlocBuilder<OsmDataCubit, OsmDataCubitState>(
            builder: (context, osmDataCubitState) {
              return Stack(
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CircleLayer(
                        circles: [
                          CircleMarker(
                            point: LatLng(
                              state.userPosition.latitude,
                              state.userPosition.longitude,
                            ),
                            color: AppColors.transparent,
                            borderColor: AppColors.primaryAccent,
                            borderStrokeWidth: .5,
                            useRadiusInMeter: true,
                            radius: osmDataCubitState is OsmDataCubitLoaded
                                ? osmDataCubitState.radius * 1000
                                : 0,
                          ),
                          CircleMarker(
                            point: LatLng(
                              state.userPosition.latitude,
                              state.userPosition.longitude,
                            ),
                            color: AppColors.transparent,
                            borderColor: AppColors.primaryAccent.withOpacity(
                              (1 - _controller.value) / 2,
                            ),
                            borderStrokeWidth: 2,
                            useRadiusInMeter: true,
                            radius: osmDataCubitState is OsmDataCubitLoaded
                                ? osmDataCubitState.radius *
                                    1000 *
                                    _controller.value
                                : 0,
                          ),
                          CircleMarker(
                            useRadiusInMeter: true,
                            point: LatLng(
                              state.userPosition.latitude,
                              state.userPosition.longitude,
                            ),
                            color: AppColors.transparentBlack,
                            borderColor: AppColors.primaryAccent.withOpacity(
                              .5,
                            ),
                            borderStrokeWidth: 2,
                            radius: state.userPosition.accuracy,
                          ),
                          CircleMarker(
                            useRadiusInMeter: true,
                            point: LatLng(
                              state.userPosition.latitude,
                              state.userPosition.longitude,
                            ),
                            color: AppColors.transparentBlack.withOpacity(
                              1 - _controller.value,
                            ),
                            borderColor: AppColors.primaryAccent.withOpacity(
                              1 - _controller.value,
                            ),
                            borderStrokeWidth: 2,
                            radius:
                                state.userPosition.accuracy * _controller.value,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
