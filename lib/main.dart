import 'package:cyber_map/core/config/environment/environment.dart';
import 'package:cyber_map/core/config/injectable/injection.dart';
import 'package:cyber_map/core/config/navigation/app_page_route_builder.dart';
import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/config/navigation/observer.dart';
import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_map_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_cubit.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/presentation/widgets/screens/home_page.dart';
import 'package:cyber_map/core/presentation/widgets/screens/map_page.dart';
import 'package:cyber_map/core/presentation/widgets/screens/missing_o_s_m_object_page.dart';
import 'package:cyber_map/core/presentation/widgets/screens/osm_object_list_page.dart';
import 'package:cyber_map/core/presentation/widgets/screens/osm_object_page.dart';
import 'package:cyber_map/core/presentation/widgets/screens/tag_list_page.dart';
import 'package:cyber_map/core/presentation/widgets/screens/tags_value_list_page.dart';
import 'package:cyber_map/core/utils/route_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(environment: Environment.dev);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<UserPositionCubit>(),
        ),
        BlocProvider(create: (context) => getIt<OsmDataCubit>()),
        BlocProvider(
          create: (context) => MapThemeCubit(),
        ),
        BlocProvider(create: (context) => getIt<EmojiTagMapCubit>()),
        BlocProvider(create: (context) => getIt<MapPositionCubit>()),
        BlocProvider(
          create: (context) => getIt<NavigationRouteCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<RoutePlannerCubit>(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final OsmDataCubit osmDataCubit = context.read<OsmDataCubit>();
    return SafeArea(
      child: WidgetsApp(
        textStyle: GoogleFonts.orbitron(),
        color: AppColors.black,
        title: 'Cyber Map',
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        navigatorKey: navigatorKey,
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
        ),
        navigatorObservers: [observer],
        onGenerateRoute: (settings) {
          if (settings.name == '/tag') {
            return AppPageRouteBuilder(
              routeName: settings.name!,
              pageBuilder: (context, animation, secondaryAnimation) {
                return const TagListPage();
              },
            );
          }

          //tag/{tagKey}
          final tagMatch = RegExp(r'^/tag/(\w+)$').firstMatch(settings.name!);

          if (tagMatch != null) {
            final key = tagMatch.group(1)!;
            return AppPageRouteBuilder(
              routeName: settings.name!,
              pageBuilder: (context, animation, secondaryAnimation) {
                return TagsValueListPage(tagKey: key);
              },
            );
          }

          // /tag/{tagKey}/{tagValue}
          final tagValueMatch =
              RegExp(r'^/tag/(\w+)/(\w+)$').firstMatch(settings.name!);

          if (tagValueMatch != null) {
            final key = tagValueMatch.group(1)!;
            final value = tagValueMatch.group(2)!;
            return AppPageRouteBuilder(
              routeName: settings.name!,
              pageBuilder: (context, animation, secondaryAnimation) {
                return BlocBuilder<OsmDataCubit, OsmDataCubitState>(
                  builder: (context, state) {
                    if (state is OsmDataCubitLoaded) {
                      final String lowerCaseKey =
                          RouteUtil.formatRouteName(key);
                      final String lowerCaseValue =
                          RouteUtil.formatRouteName(value);
                      return OSMObjectListPage(
                        osmObjects: state.tagMap[lowerCaseKey]![lowerCaseValue]!
                            .toSet(),
                        title: 'Objects with tag $lowerCaseKey=$lowerCaseValue',
                      );
                    }
                    return const Text('Loading');
                  },
                );
              },
            );
          }
          if (settings.name == '/map') {
            return AppPageRouteBuilder(
              routeName: settings.name!,
              pageBuilder: (context, animation, secondaryAnimation) {
                return const MapPage();
              },
            );
          }

          // map/{lat}/{lon}

          final mapMatch =
              RegExp(r'^/map/([\d.-]+)/([\d.-]+)$').firstMatch(settings.name!);
          if (mapMatch != null) {
            final lat = double.parse(mapMatch.group(1)!);
            final lon = double.parse(mapMatch.group(2)!);
            return AppPageRouteBuilder(
              routeName: settings.name!,
              pageBuilder: (context, animation, secondaryAnimation) {
                return MapPage(
                  center: LatLng(lat, lon),
                );
              },
            );
          }
          final nodeMatch = RegExp(r'^/node/(\d+)$').firstMatch(settings.name!);
          if (nodeMatch != null) {
            final id = int.parse(nodeMatch.group(1)!);

            return AppPageRouteBuilder(
              routeName: settings.name!,
              pageBuilder: (context, animation, secondaryAnimation) {
                if (osmDataCubit.state is OsmDataCubitLoaded) {
                  return OSMObjectPage(
                    osmObject: (osmDataCubit.state as OsmDataCubitLoaded)
                        .getObject(OSMType.node, id),
                  );
                }

                return MissingOSMObjectPage(
                  id: id,
                  type: OSMType.node,
                );
              },
            );
          }
          final wayMatch = RegExp(r'^/way/(\d+)$').firstMatch(settings.name!);
          if (wayMatch != null) {
            final id = int.parse(wayMatch.group(1)!);
            return AppPageRouteBuilder(
              routeName: settings.name!,
              pageBuilder: (context, animation, secondaryAnimation) {
                if (osmDataCubit.state is OsmDataCubitLoaded) {
                  return OSMObjectPage(
                    osmObject: (osmDataCubit.state as OsmDataCubitLoaded)
                        .getObject(OSMType.way, id),
                  );
                }
                return const Text('Loading');
              },
            );
          }

          final relationMatch =
              RegExp(r'^/relation/(\d+)$').firstMatch(settings.name!);

          if (relationMatch != null) {
            final id = int.parse(relationMatch.group(1)!);
            return AppPageRouteBuilder(
              routeName: settings.name!,
              pageBuilder: (context, animation, secondaryAnimation) {
                if (osmDataCubit.state is OsmDataCubitLoaded) {
                  return OSMObjectPage(
                    osmObject: (osmDataCubit.state as OsmDataCubitLoaded)
                        .getObject(OSMType.relation, id),
                  );
                }
                return MissingOSMObjectPage(
                  id: id,
                  type: OSMType.relation,
                );
              },
            );
          }

          return null;
        },
      ),
    );
  }
}
