import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_state.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/material.dart';

class InstructionMarkerPopUp extends StatelessWidget {
  const InstructionMarkerPopUp({
    super.key,
    required this.marker,
  });

  final RoadInstructionMarker marker;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 60,
          width: 250,
          child: Column(
            children: [
              Text(
                '${marker.instruction.distance}m, ${marker.instruction.duration.inSeconds}s',
                style: const TextStyle(
                  color: AppColors.primaryAccent,
                  fontSize: 20,
                ),
              ),
              FittedBox(
                child: Text(
                  marker.instruction.instruction,
                  style: const TextStyle(
                    color: AppColors.primaryAccent,
                    fontSize: 20,
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
