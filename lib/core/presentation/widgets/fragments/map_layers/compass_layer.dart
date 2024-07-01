import 'dart:math';

import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_state.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class CompassLayer extends StatelessWidget {
  const CompassLayer({
    required this.isMapLocked,
    required this.onTap,
  });
  final bool isMapLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<MapPositionCubit, MapPositionState>(
              builder: (context, state) {
                if (state is MapPositionStateLoaded) {
                  return CompassWidget(
                    rotation: state.rotation,
                    isHighlighted: isMapLocked,
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CompassWidget extends StatelessWidget {
  const CompassWidget({
    required this.rotation,
    this.isHighlighted = false,
    this.staticLabels = false,
  });
  final double rotation;
  final bool isHighlighted;
  final bool staticLabels;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * (pi / 180),
      child: SizedBox(
        height: 60,
        width: 60,
        child: AppContainer(
          backgroundColor: AppColors.black,
          borderColor: isHighlighted
              ? AppColors.primaryAccent
              : AppColors.transparentBlack,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: CompassRoseLinePainter(rotation - 90),
              ),
              _buildCardinalLabel(
                'N',
                0,
                Alignment.topCenter + const Alignment(0, 0.1),
              ),
              _buildCardinalLabel(
                'S',
                180,
                Alignment.bottomCenter - const Alignment(0, 0.1),
              ),
              _buildCardinalLabel(
                'E',
                90,
                Alignment.centerRight - const Alignment(0.1, 0),
              ),
              _buildCardinalLabel(
                'W',
                270,
                Alignment.centerLeft + const Alignment(0.1, 0),
              ),
              const SizedBox(
                height: 60,
                width: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardinalLabel(
    String direction,
    double cardinalRotation,
    Alignment alignment,
  ) {
    final double difference =
        (360 + (-rotation % 360 - cardinalRotation) % 360) % 360;
    final double adjustedDifference =
        difference > 180 ? 360 - difference : difference;

    final color = Color.lerp(
      AppColors.white,
      AppColors.white.withOpacity(0.25),
      adjustedDifference / 180,
    );
    return Align(
      alignment: alignment,
      child: staticLabels
          ? Text(direction, style: TextStyle(color: color))
          : Transform.rotate(
              angle: -rotation * (pi / 180),
              child: Text(direction, style: TextStyle(color: color)),
            ),
    );
  }
}

class CompassRoseLinePainter extends CustomPainter {
  CompassRoseLinePainter(this.rotation);
  int qtyOfLines = 16;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    const double strokeWidth = 1;
    const double lineOffset = 30;

    for (int i = 0; i < qtyOfLines; i++) {
      final double angle = i * 360 / qtyOfLines;
      final double lineLength = (i % 4 == 0)
          ? 7
          : (i.isEven)
              ? 5
              : 3;
      final double x1 = radius + (radius - lineOffset) * cos(angle * pi / 180);
      final double y1 = radius + (radius - lineOffset) * sin(angle * pi / 180);
      final double x2 =
          radius + (radius - lineOffset - lineLength) * cos(angle * pi / 180);
      final double y2 =
          radius + (radius - lineOffset - lineLength) * sin(angle * pi / 180);

      final double difference = (360 + (-rotation % 360 - angle) % 360) % 360;
      final double adjustedDifference =
          difference > 180 ? 360 - difference : difference;

      final Paint paint = Paint()
        ..color = Color.lerp(
          AppColors.white,
          AppColors.white.withOpacity(0.25),
          adjustedDifference / 180,
        )!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
