import 'package:cyber_map/core/domain/models/navigation_instruction/navigation_instruction.dart';

class LatLngInstruction extends NavigationInstruction {
  LatLngInstruction({
    required super.instruction,
    required super.duration,
    required super.distance,
    required super.location,
  });
}
