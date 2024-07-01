import 'package:cyber_map/core/domain/models/user_position/user_position.dart';

abstract class UserPositionState {
  const UserPositionState();
}

class UserPositionInitial extends UserPositionState {
  const UserPositionInitial() : super();
}

class UserPositionLoading extends UserPositionState {
  const UserPositionLoading() : super();
}

class UserPositionLoaded extends UserPositionState {
  const UserPositionLoaded({
    required this.userPosition,
  }) : super();

  final UserPosition userPosition;
}

class UserPositionError extends UserPositionState {
  const UserPositionError({
    required this.error,
  }) : super();

  final String error;
}
