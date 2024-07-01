import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/config/theme/app_icons.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/material.dart';

class OsmObjectButton extends StatelessWidget {
  const OsmObjectButton({
    required this.osmObject,
    required this.onSelected,
    required this.onMapIconPressed,
    required this.isInRoutePlanner,
    this.borderColor = AppColors.primaryAccent,
  });

  final OSMObject osmObject;
  final void Function(OSMObject) onSelected;
  final VoidCallback onMapIconPressed;
  final Color borderColor;
  final bool isInRoutePlanner;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(osmObject);
      },
      child: SizedBox(
        height: 48,
        child: AppContainer(
          borderColor: borderColor,
          backgroundColor: AppColors.black,
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown, // Add this line
                  child: Text(
                    osmObject.label,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: onMapIconPressed,
                  //navigation pin emoji
                  child: AppContainer(
                    child: Icon(
                      AppIcons.pin_drop,
                      color: isInRoutePlanner
                          ? AppColors.primaryAccent
                          : AppColors.white,
                      size: 30,
                    ),
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
