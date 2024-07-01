import 'package:cyber_map/core/presentation/widgets/fragments/map_widget.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:latlong2/latlong.dart' hide Path;

class MapPage extends StatelessWidget {
  const MapPage({super.key, this.center});

  final LatLng? center;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.vertical -
          MediaQuery.of(context).padding.vertical,
      width: MediaQuery.sizeOf(context).width,
      child: MapWidget(center: center),
    );
  }
}
