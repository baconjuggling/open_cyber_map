import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/map_menus/key_menu.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/map_menus/route_planner_menu.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/map_menus/vector_layer_menu.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MenuLayer extends StatefulWidget {
  const MenuLayer({
    required this.popupController,
    required this.animatedMapController,
  });

  final PopupController popupController;
  final AnimatedMapController animatedMapController;

  @override
  State<MenuLayer> createState() => _MenuLayerState();
}

class _MenuLayerState extends State<MenuLayer> {
  @override
  Widget build(BuildContext context) {
    return SlidingMenuGroup(
      popupController: widget.popupController,
      animatedMapController: widget.animatedMapController,
    );
  }
}

enum SlidingMenuState { key, settings, none, navigation, mapLayers }

class SlidingMenuGroup extends StatefulWidget {
  const SlidingMenuGroup({
    required this.popupController,
    required this.animatedMapController,
  });

  final PopupController popupController;
  final AnimatedMapController animatedMapController;

  @override
  State<SlidingMenuGroup> createState() => _SlidingMenuGroupState();
}

class _SlidingMenuGroupState extends State<SlidingMenuGroup> {
  SlidingMenuState _expandedRightMenu = SlidingMenuState.none;
  SlidingMenuState _expandedLeftMenu = SlidingMenuState.none;
  SlidingMenuState _expandedTopMenu = SlidingMenuState.none;
  SlidingMenuState _expandedBottomMenu = SlidingMenuState.none;

  bool menusOffstaged = true;

  Future<void> _toggleMenu(
    SlidingMenuState menu,
    SlideDirection direction,
  ) async {
    setState(() {
      if (direction == SlideDirection.right) {
        _expandedRightMenu =
            _expandedRightMenu == menu ? SlidingMenuState.none : menu;
      } else if (direction == SlideDirection.left) {
        _expandedLeftMenu =
            _expandedLeftMenu == menu ? SlidingMenuState.none : menu;
      } else if (direction == SlideDirection.top) {
        _expandedTopMenu =
            _expandedTopMenu == menu ? SlidingMenuState.none : menu;
      } else if (direction == SlideDirection.bottom) {
        _expandedBottomMenu =
            _expandedBottomMenu == menu ? SlidingMenuState.none : menu;
      }
    });

    if (_expandedRightMenu == SlidingMenuState.none &&
        _expandedLeftMenu == SlidingMenuState.none &&
        _expandedTopMenu == SlidingMenuState.none &&
        _expandedBottomMenu == SlidingMenuState.none) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        menusOffstaged = true;
      });
      // off
    } else {
      setState(() {
        menusOffstaged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlidingMenuButtonGroup(
          buttons: [
            SlidingMenuTriggerButton(
              emoji: '🔑',
              isSelected: _expandedRightMenu == SlidingMenuState.key,
              onTap: () {
                _toggleMenu(SlidingMenuState.key, SlideDirection.right);
              },
            ),
            SlidingMenuTriggerButton(
              emoji: '🧭',
              isSelected: _expandedRightMenu == SlidingMenuState.navigation,
              onTap: () {
                _toggleMenu(SlidingMenuState.navigation, SlideDirection.right);
              },
            ),
            SlidingMenuTriggerButton(
              emoji: '⚙️',
              isSelected: _expandedRightMenu == SlidingMenuState.settings,
              onTap: () {
                _toggleMenu(SlidingMenuState.settings, SlideDirection.right);
              },
            ),
            SlidingMenuTriggerButton(
              emoji: '🎨',
              isSelected: _expandedRightMenu == SlidingMenuState.mapLayers,
              onTap: () {
                _toggleMenu(SlidingMenuState.mapLayers, SlideDirection.right);
              },
            ),
            const Spacer(),
            SlidingMenuButton(
              emoji: '🏠',
              onTap: () {
                navigatorKey.currentState!.pop();
              },
            ),
          ],
          direction: SlideDirection.right,
          isExpanded: _expandedRightMenu != SlidingMenuState.none,
          menuHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
          menuWidth: 200,
        ),
        SlidingMenuPanel(
          offstage: menusOffstaged,
          isExpanded: _expandedRightMenu == SlidingMenuState.key,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
          width: 200,
          child: KeyMenu(
            popupController: widget.popupController,
            animatedMapController: widget.animatedMapController,
          ),
        ),
        SlidingMenuPanel(
          offstage: menusOffstaged,
          isExpanded: _expandedRightMenu == SlidingMenuState.settings,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
          width: 200,
          child: const Center(child: Text('Settings')),
        ),
        SlidingMenuPanel(
          offstage: menusOffstaged,
          isExpanded: _expandedRightMenu == SlidingMenuState.navigation,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
          width: 200,
          child: RoutePlannerMenu(
            animatedMapController: widget.animatedMapController,
          ),
        ),
        SlidingMenuPanel(
          offstage: menusOffstaged,
          isExpanded: _expandedRightMenu == SlidingMenuState.mapLayers,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
          width: 200,
          child: const VectorLayerMenu(),
        ),
      ],
    );
  }
}

enum SlideDirection { right, left, top, bottom }

class SlidingMenuPanel extends StatelessWidget {
  const SlidingMenuPanel({
    required this.child,
    required this.isExpanded,
    required this.width,
    required this.height,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
    this.direction = SlideDirection.right,
    required this.offstage,
  });
  final Widget child;
  final bool isExpanded;
  final double width;
  final double height;
  final Duration duration;
  final Curve curve;
  final SlideDirection direction;
  final bool offstage;

  @override
  Widget build(BuildContext context) {
    double? top;
    double? bottom;
    double? left;
    double? right;

    switch (direction) {
      case SlideDirection.right:
        right = isExpanded ? 0 : -width - 3;
      case SlideDirection.left:
        left = isExpanded ? 0 : -width - 3;
      case SlideDirection.top:
        top = isExpanded ? 0 : -height - 3;
      case SlideDirection.bottom:
        bottom = isExpanded ? 0 : -height - 3;
    }
    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Offstage(
        offstage: offstage,
        child: AppContainer(
          child: SizedBox(
            height: height,
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }
}

class SlidingMenuButton extends StatelessWidget {
  const SlidingMenuButton({
    required this.emoji,
    required this.onTap,
  });
  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        width: 60,
        child: AppContainer(
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
      ),
    );
  }
}

class SlidingMenuTriggerButton extends StatelessWidget {
  const SlidingMenuTriggerButton({
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isSelected ? 1 : .8,
      child: SlidingMenuButton(
        emoji: emoji,
        onTap: onTap,
      ),
    );
  }
}

class SlidingMenuButtonGroup extends StatelessWidget {
  const SlidingMenuButtonGroup({
    required this.buttons,
    required this.direction,
    required this.isExpanded,
    required this.menuHeight,
    required this.menuWidth,
  });
  final List<Widget> buttons;
  final SlideDirection direction;
  final bool isExpanded;
  final double menuHeight;
  final double menuWidth;

  @override
  Widget build(BuildContext context) {
    double? top;
    double? bottom;
    double? left;
    double? right;

    switch (direction) {
      case SlideDirection.right:
        right = isExpanded ? menuWidth : 0;
      case SlideDirection.left:
        left = isExpanded ? menuWidth : 0;
      case SlideDirection.top:
        top = isExpanded ? menuHeight : 0;
      case SlideDirection.bottom:
        bottom = isExpanded ? menuHeight : 0;
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child:
          direction == SlideDirection.top || direction == SlideDirection.bottom
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Row(
                    children: buttons,
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical -
                      60,
                  width: 60,
                  child: Column(
                    children: buttons,
                  ),
                ),
    );
  }
}
