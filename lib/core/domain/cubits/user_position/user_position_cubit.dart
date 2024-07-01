import 'dart:developer';
import 'dart:io';

import 'package:cyber_map/core/domain/cubits/user_position/user_position_state.dart';
import 'package:cyber_map/core/domain/models/user_position/user_position.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

@singleton
@injectable
class UserPositionCubit extends Cubit<UserPositionState> {
  UserPositionCubit() : super(const UserPositionInitial()) {
    startServices();
  }

  void updateUserPosition(UserPosition userPosition) =>
      emit(UserPositionLoaded(userPosition: userPosition));

  void startServices() {
    _startCompassService();
    _startLocationService();
  }

  UserPosition createUserPosition(
    double latitude,
    double longitude,
    double heading,
    double accuracy,
  ) {
    return UserPosition(
      latitude: latitude,
      longitude: longitude,
      heading: heading,
      accuracy: accuracy,
    );
  }

  void _startCompassService() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        FlutterCompass.events!.listen((event) {
          if (event.heading != null) {
            final UserPosition userPosition = createUserPosition(
              state is UserPositionLoaded
                  ? (state as UserPositionLoaded).userPosition.latitude
                  : 0,
              state is UserPositionLoaded
                  ? (state as UserPositionLoaded).userPosition.longitude
                  : 0,
              event.heading!,
              state is UserPositionLoaded
                  ? (state as UserPositionLoaded).userPosition.accuracy
                  : 0,
            );
            emit(UserPositionLoaded(userPosition: userPosition));
          }
        });
      } else {
        final UserPosition userPosition = createUserPosition(
          state is UserPositionLoaded
              ? (state as UserPositionLoaded).userPosition.latitude
              : 0,
          state is UserPositionLoaded
              ? (state as UserPositionLoaded).userPosition.longitude
              : 0,
          0,
          state is UserPositionLoaded
              ? (state as UserPositionLoaded).userPosition.accuracy
              : 0,
        );
        emit(UserPositionLoaded(userPosition: userPosition));
      }
    } catch (e) {
      emit(UserPositionError(error: e.toString()));
    }
  }

  void _startLocationService() {
    try {
      final location = Location();
      location.requestPermission().then((permission) {
        if (permission == PermissionStatus.granted) {
          location.serviceEnabled().then((serviceEnabled) {
            if (serviceEnabled) {
              location.onLocationChanged.listen((event) {
                final UserPosition userPosition = createUserPosition(
                  event.latitude!,
                  event.longitude!,
                  state is UserPositionLoaded
                      ? (state as UserPositionLoaded).userPosition.heading
                      : 0,
                  event.accuracy!,
                );
                emit(UserPositionLoaded(userPosition: userPosition));
              });
            } else {
              log('Location service is not enabled');
            }
          });
        } else {
          log('Location permission is not granted');
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
