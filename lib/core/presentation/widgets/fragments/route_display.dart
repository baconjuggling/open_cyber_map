import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/config/navigation/observer.dart';
import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteDisplay extends StatelessWidget {
  const RouteDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColors.primaryAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    'Path: ',
                    style: GoogleFonts.orbitron(
                      color: AppColors.black,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
            for (final routeString in pseudoRouteStack) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: GestureDetector(
                  onTap: () {
                    popUntilNavigatorStackIndex(
                      pseudoRouteStack.indexOf(routeString),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Wrap(
                      children: [
                        Text(
                          routeString,
                          style: GoogleFonts.orbitron(
                            color: AppColors.white,
                            fontSize: 10,
                          ),
                        ),
                        if (routeString != pseudoRouteStack.last) ...[
                          const SizedBox(width: 8),
                          const Text(
                            ' > ',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<String> get pseudoRouteStack {
    final List<String> routeStack = [];
    final stack = observer.routeStack.toList();

    for (final route in stack) {
      if (stack.indexOf(route) == 0) {
        routeStack.add('home');
      } else if (route.settings.name.toString().contains('node/')) {
        routeStack.add('node: ${route.settings.name.toString().split('/')[2]}');
      } else if (route.settings.name.toString().contains('node')) {
        routeStack.add('node_list');
      } else if (route.settings.name.toString().contains('way/')) {
        routeStack.add('way: ${route.settings.name.toString().split('/')[2]}');
      } else if (route.settings.name.toString().contains('way')) {
        routeStack.add('way_list');
      } else if (route.settings.name.toString().contains('relation/')) {
        routeStack
            .add('relation: ${route.settings.name.toString().split('/')[2]}');
      } else if (route.settings.name.toString().contains('relation')) {
        routeStack.add('relation_list');
      } else if (route.settings.name.toString().contains('tag/')) {
        final split = route.settings.name.toString().split('/');
        if (split.length == 3) {
          routeStack.add(split[2]);
        } else {
          routeStack.add(split[3]);
        }
      } else if (route.settings.name.toString().contains('tag')) {
        routeStack.add('tag_list');
      } else {
        routeStack.add('${route.settings.name}');
      }
    }

    return routeStack;
  }

  void popUntilNavigatorStackIndex(int index) {
    navigatorKey.currentState!.popUntil((route) {
      final currentIndex = observer.routeStack.indexOf(route);
      return currentIndex == index;
    });
  }
}
