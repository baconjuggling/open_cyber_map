import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapTopToolbar extends StatelessWidget {
  const MapTopToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.transparentPrimaryAccent,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: AppColors.primaryAccent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppRoundedButton(
              label: 'Back',
              onTap: () {
                navigatorKey.currentState?.pop();
              },
            ),
            BlocBuilder<OsmDataCubit, OsmDataCubitState>(
              builder: (context, state) {
                return AppRoundedButton(
                  enabled: state is OsmDataCubitLoaded ||
                      state is OsmDataCubitInitial,
                  label: 'Get Nodes',
                  onTap: () async {
                    context.read<OsmDataCubit>().fetchOSMObjects();
                  },
                );
              },
            ),
            AppRoundedButton(
              label: "Load local osm",
              onTap: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
