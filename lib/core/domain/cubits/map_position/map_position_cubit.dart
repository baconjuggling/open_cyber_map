import 'package:cyber_map/core/domain/cubits/map_position/map_position_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
@singleton
class MapPositionCubit extends Cubit<MapPositionState> {
  MapPositionCubit()
      : super(
          MapPositionStateLoaded(
            position: const LatLng(52.57127, 0.82586),
            zoom: 10,
            rotation: 0,
          ),
        );

  void updateMapPosition(
    LatLng position,
    double zoom,
    double rotation,
  ) {
    emit(
      MapPositionStateLoaded(
        position: position,
        zoom: zoom,
        rotation: rotation,
      ),
    );
  }
}
