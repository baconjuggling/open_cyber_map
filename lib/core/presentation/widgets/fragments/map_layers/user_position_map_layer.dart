import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/config/theme/app_icons.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserPositionMapLayer extends StatelessWidget {
  const UserPositionMapLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPositionCubit, UserPositionState>(
      builder: (context, state) {
        if (state is UserPositionLoaded) {
          return MarkerLayer(
            markers: [
              Marker(
                alignment: Alignment.center,
                point: LatLng(
                  state.userPosition.latitude,
                  state.userPosition.longitude,
                ),
                child: Transform.rotate(
                  angle: state.userPosition.heading * (pi / 180),
                  child: const Icon(
                    AppIcons.navigation,
                    color: AppColors.primaryAccent,
                    size: 30,
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                      ),
                      Shadow(
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
