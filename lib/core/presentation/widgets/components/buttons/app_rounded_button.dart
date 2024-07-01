import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';

class AppRoundedButton extends StatefulWidget {
  const AppRoundedButton({
    required this.label,
    required this.onTap,
    this.borderColor = AppColors.primaryAccent,
    this.icon,
    this.enabled = true,
    super.key,
  });
  final String label;
  final Color borderColor;
  final VoidCallback onTap;
  final Widget? icon;
  final bool enabled;

  @override
  State<AppRoundedButton> createState() => _AppRoundedButtonState();
}

class _AppRoundedButtonState extends State<AppRoundedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        onTapDown: (_) {
          widget.enabled ? _controller.forward() : null;
        },
        onTapUp: (_) {
          if (_controller.isAnimating || _controller.isCompleted) {
            _controller.reverse();
          }
        },
        onTapCancel: () {
          if (_controller.isAnimating || _controller.isCompleted) {
            _controller.reverse();
          }
        },
        child: AppContainer(
          borderColor: widget.enabled ? widget.borderColor : AppColors.grey,
          boxShadows: [
            BoxShadow(
              color: Color.lerp(
                    AppColors.transparent,
                    widget.enabled ? widget.borderColor : AppColors.transparent,
                    _controller.value,
                  ) ??
                  AppColors.transparent,
              blurRadius: 3,
              spreadRadius: 3,
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(widget.label),
                if (widget.icon != null) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: widget.icon,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
