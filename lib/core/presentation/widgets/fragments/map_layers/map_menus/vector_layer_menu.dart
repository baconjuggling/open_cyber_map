import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit_state.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/vector_map_layer_category_panel.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/vector_layer_menu_item.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VectorLayerMenu extends StatefulWidget {
  const VectorLayerMenu({
    super.key,
  });

  @override
  State<VectorLayerMenu> createState() => _VectorLayerMenuState();
}

class _VectorLayerMenuState extends State<VectorLayerMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapThemeCubit, MapThemeCubitState>(
      builder: (context, state) {
        return ListView(
          children: [
            const Center(child: Text('Map Layers')),
            AppRoundedButton(
              label: "import style",
              onTap: () {
                context.read<MapThemeCubit>().importThemeData();
              },
            ),
            AppRoundedButton(
              label: "export style",
              onTap: () async {
                await context.read<MapThemeCubit>().exportThemeData();
              },
            ),
            AppRoundedButton(
              label: "reset style",
              onTap: () {
                context.read<MapThemeCubit>().resetMapTheme();
              },
            ),
            if (state is MapThemeCubitStateLoaded) ...[
              for (final sourceLayer in state.sourceLayers.keys)
                VectorMapLayerCategoryPanel(
                  category: sourceLayer,
                ),
              for (final layer in state.layersWithoutSource)
                VectorLayerMenuItem(
                  layer: state.themeData['layers']
                          .firstWhere((element) => element['id'] == layer)
                      as Map<String, dynamic>,
                ),
            ],
          ],
        );
      },
    );
  }
}
