import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit_state.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/map_theme_property_with_stops.dart';
import 'package:cyber_map/core/presentation/widgets/components/app_color_indicator.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_check_box.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:cyber_map/core/presentation/widgets/components/sliders/app_slider.dart';
import 'package:cyber_map/core/utils/extensions/string/to_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VectorLayerMenuItem extends StatefulWidget {
  const VectorLayerMenuItem({
    super.key,
    required this.layer,
  });

  final Map layer;

  @override
  _VectorLayerMenuItemState createState() => _VectorLayerMenuItemState();
}

class _VectorLayerMenuItemState extends State<VectorLayerMenuItem> {
  bool isColorPickerVisible = false;
  double opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapThemeCubit, MapThemeCubitState>(
      builder: (context, state) {
        if (state is! MapThemeCubitStateLoaded) {
          return const SizedBox();
        }
        return AppContainer(
          borderColor: state.getPaintColor(widget.layer['id'] as String)
                  is MapThemePropertyWithStops
              ? (state.getPaintColor(widget.layer['id'] as String)
                      as MapThemePropertyWithStops)
                  .stops
                  .first[1]
                  .toString()
                  .colorFromMapColorString()!
              : state
                  .getPaintColor(widget.layer['id'] as String)
                  .toMapThemeData
                  .toString()
                  .colorFromMapColorString()!,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    if (widget.layer['type'] != 'background')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppCheckBox(
                          enabled: widget.layer['layout'] != null &&
                                  widget.layer['layout']?['visibility'] ==
                                      'visible'
                              ? true
                              : false,
                          onTap: () async {
                            await context
                                .read<MapThemeCubit>()
                                .toggleLayer(widget.layer['id'] as String);
                            context.read<MapThemeCubit>().saveMapTheme();
                          },
                        ),
                      ),
                    Expanded(
                      child: FittedBox(
                        child: Text(widget.layer['id'] as String),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isColorPickerVisible = !isColorPickerVisible;
                        });
                      },
                      child: AppColorIndicator(
                        color: state.getPaintColor(widget.layer['id'] as String)
                                is MapThemePropertyWithStops
                            ? (state.getPaintColor(widget.layer['id'] as String)
                                    as MapThemePropertyWithStops)
                                .stops
                                .first[1]
                                .toString()
                                .colorFromMapColorString()!
                            : state
                                .getPaintColor(widget.layer['id'] as String)
                                .toMapThemeData
                                .toString()
                                .colorFromMapColorString()!,
                      ),
                    ),
                  ],
                ),
                if (isColorPickerVisible) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final Color color in [
                          ...AppColors.colors,
                        ])
                          GestureDetector(
                            onTap: () {
                              context.read<MapThemeCubit>().setPaintColor(
                                    widget.layer['id'] as String,
                                    color.withOpacity(opacity),
                                  );
                              setState(() {
                                isColorPickerVisible = false;
                              });
                              context.read<MapThemeCubit>().saveMapTheme();
                            },
                            child: AppColorIndicator(
                              color: color.withOpacity(opacity),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppSlider(
                    value: (opacity * 255).toInt(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      setState(() {
                        opacity = value / 255;
                      });
                    },
                    onRelease: (value) {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
                for (final property in widget.layer.entries)
                  if (property.key != 'id' && property.key != 'type') ...[
                    Text('${property.key}:'),
                    Text('${property.value}'),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }
}
