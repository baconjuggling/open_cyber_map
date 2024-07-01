import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit_state.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/map_theme_property.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/map_theme_property_with_stops.dart';
import 'package:cyber_map/core/presentation/widgets/components/app_color_indicator.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_check_box.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/expansion_app_container.dart';
import 'package:cyber_map/core/presentation/widgets/components/sliders/app_slider.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/vector_layer_menu_item.dart';
import 'package:cyber_map/core/utils/extensions/string/to_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VectorMapLayerCategoryPanel extends StatefulWidget {
  const VectorMapLayerCategoryPanel({
    super.key,
    required this.category,
  });

  final String category;

  @override
  State<VectorMapLayerCategoryPanel> createState() =>
      _VectorMapLayerCategoryPanelState();
}

class _VectorMapLayerCategoryPanelState
    extends State<VectorMapLayerCategoryPanel> {
  bool _isColorPickerVisible = false;
  double _opacity = 1.0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapThemeCubit, MapThemeCubitState>(
      builder: (context, state) {
        return ExpansionAppContainer(
          title: widget.category,
          subtitle: 'Layers in ${widget.category}',
          child: Column(
            children: [
              if (state is MapThemeCubitStateLoaded) ...[
                AppCheckBox(
                  enabled: state.sourceLayers[widget.category]!.any(
                    (element) => state.themeData['layers'].any(
                      (layer) =>
                          layer['id'] == element &&
                          layer['layout'] != null &&
                          layer['layout']['visibility'] == 'visible',
                    ) as bool,
                  ),
                  onTap: () {
                    final bool anyVisible = state.themeData['layers'].any(
                      (element) =>
                          state.sourceLayers[widget.category]!
                              .contains(element['id']) &&
                          element['layout'] != null &&
                          element['layout']['visibility'] == 'visible',
                    ) as bool;

                    for (final layerId
                        in state.sourceLayers[widget.category]!) {
                      context.read<MapThemeCubit>().setLayerVisibility(
                            layerId,
                            anyVisible ? 'none' : 'visible',
                          );
                    }
                    context.read<MapThemeCubit>().saveMapTheme();
                  },
                ),
                FittedBox(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isColorPickerVisible = !_isColorPickerVisible;
                      });
                    },
                    child: AppColorIndicator(
                      color: state.sourceLayers[widget.category]!.isEmpty
                          ? AppColors.transparent
                          : state.getPaintColor(
                              state.sourceLayers[widget.category]!.first,
                            ) is MapThemePropertyWithStops
                              ? (state.getPaintColor(
                                    state.sourceLayers[widget.category]!.first,
                                  ) as MapThemePropertyWithStops)
                                      .stops
                                      .first[1]
                                      .toString()
                                      .colorFromMapColorString() ??
                                  AppColors.transparent
                              : (state.getPaintColor(
                                  state.sourceLayers[widget.category]!.first,
                                ) as MapThemeProperty<Color>)
                                  .value,
                    ),
                  ),
                ),
                if (_isColorPickerVisible) ...[
                  SizedBox(
                    width: 200,
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final Color color in AppColors.colors)
                          GestureDetector(
                            onTap: () {
                              for (final layerId
                                  in state.sourceLayers[widget.category]!) {
                                if (layerId != 'background') {
                                  context.read<MapThemeCubit>().setPaintColor(
                                        layerId,
                                        color.withOpacity(_opacity),
                                      );
                                }
                                setState(() {
                                  _isColorPickerVisible = false;
                                });
                              }
                              context.read<MapThemeCubit>().saveMapTheme();
                            },
                            child: AppColorIndicator(
                              color: color.withOpacity(_opacity),
                            ),
                          ),
                      ],
                    ),
                  ),
                  AppSlider(
                    value: (_opacity * 255).toInt(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      setState(() {
                        _opacity = value / 255;
                      });
                    },
                    onRelease: (value) {},
                  ),
                ],
                for (final layerId in state.sourceLayers[widget.category]!) ...[
                  if (state.themeData['layers'].any(
                    (element) => element['id'] == layerId,
                  ) as bool)
                    VectorLayerMenuItem(
                      layer: (state.themeData['layers'] as List)
                          .map((item) => item as Map)
                          .toList()
                          .firstWhere(
                            (element) => element['id'] == layerId,
                          ),
                    )
                  else
                    const SizedBox(),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
