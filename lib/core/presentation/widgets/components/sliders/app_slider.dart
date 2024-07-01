import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class AppSlider extends StatefulWidget {
  const AppSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.onRelease,
  });
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final ValueChanged<int> onRelease;

  @override
  _AppSliderState createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  late double _value;
  late double _startPos;

  @override
  void initState() {
    super.initState();
    _value = (widget.value - widget.min) / (widget.max - widget.min);
  }

  @override
  Widget build(BuildContext context) {
    const thumbWidth = 20.0;

    return SizedBox(
      height: 30,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final trackWidth = constraints.maxWidth - thumbWidth;

          return GestureDetector(
            onTapUp: (details) {
              setState(() {
                _value =
                    details.localPosition.dx.clamp(0, trackWidth) / trackWidth;
              });
              final newValue =
                  (_value * (widget.max - widget.min) + widget.min).round();
              widget.onChanged(newValue);
              widget.onRelease(newValue);
            },
            child: Stack(
              children: [
                //track bar
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.transparentPrimaryAccent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                //thumb
                Positioned(
                  left: _value * trackWidth,
                  child: GestureDetector(
                    onHorizontalDragStart: (details) {
                      _startPos = details.localPosition.dx;
                    },
                    onHorizontalDragUpdate: (details) {
                      final delta = details.localPosition.dx - _startPos;
                      _startPos = details.localPosition.dx;
                      setState(() {
                        _value = (_value + delta / trackWidth).clamp(0.0, 1.0);
                      });
                      final newValue =
                          (_value * (widget.max - widget.min) + widget.min)
                              .round();
                      widget.onChanged(newValue);
                    },
                    onHorizontalDragEnd: (details) {
                      final newValue =
                          (_value * (widget.max - widget.min) + widget.min)
                              .round();
                      widget.onRelease(newValue);
                    },
                    child: Container(
                      height: 20,
                      width: thumbWidth,
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
