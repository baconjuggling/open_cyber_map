import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/config/theme/app_icons.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/material.dart';

class ExpansionAppContainer extends StatefulWidget {
  const ExpansionAppContainer({
    required this.title,
    required this.subtitle,
    required this.child,
    this.borderColor,
    this.backgroundColor,
  });
  final String title;
  final String subtitle;
  final Widget child;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  _ExpansionAppContainerState createState() => _ExpansionAppContainerState();
}

class _ExpansionAppContainerState extends State<ExpansionAppContainer> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      borderColor: widget.borderColor ?? AppColors.primaryAccent,
      backgroundColor: widget.backgroundColor ?? AppColors.transparentBlack,
      child: Column(
        children: [
          AppContainer(
            borderColor: widget.borderColor ?? AppColors.primaryAccent,
            backgroundColor: AppColors.black,
            child: SizedBox(
              height: 60,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    child: AppContainer(
                      backgroundColor: AppColors.black,
                      borderColor:
                          widget.borderColor ?? AppColors.primaryAccent,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Icon(
                          _expanded
                              ? AppIcons.arrow_drop_up
                              : AppIcons.arrow_drop_down,
                          size: 30,
                          color: widget.borderColor ?? AppColors.primaryAccent,
                          semanticLabel: _expanded
                              ? 'Collapse ${widget.title}'
                              : 'Expand ${widget.title}',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Text(
                            widget.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) widget.child,
        ],
      ),
    );
  }
}
