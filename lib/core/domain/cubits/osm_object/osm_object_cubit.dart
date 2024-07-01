import 'dart:developer';

import 'package:cyber_map/core/config/injectable/injection.dart';
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_map_cubit.dart';
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_state.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/domain/models/relation/relation.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/domain/repositories/i_local_osm_repository.dart';
import 'package:cyber_map/core/domain/repositories/i_osm_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
@singleton
class OsmDataCubit extends Cubit<OsmDataCubitState> {
  OsmDataCubit() : super(const OsmDataCubitInitial()) {
    loadInitialData();
  }

  final IOSMRepository _overpassRepository = getIt<IOSMRepository>();

  final ILocalOSMRepository _localOSMRepository = getIt<ILocalOSMRepository>();

  final EmojiTagMapCubit emojiTagMapCubit = getIt<EmojiTagMapCubit>();

  final UserPositionCubit userPositionCubit = getIt<UserPositionCubit>();

  void setRadius(double radius) {
    if (state is OsmDataCubitLoaded) {
      emit(
        OsmDataCubitLoaded(
          nodeMap: (state as OsmDataCubitLoaded).nodeMap,
          wayMap: (state as OsmDataCubitLoaded).wayMap,
          relationMap: (state as OsmDataCubitLoaded).relationMap,
          radius: radius,
          center: LatLng(
            (userPositionCubit.state as UserPositionLoaded)
                .userPosition
                .latitude,
            (userPositionCubit.state as UserPositionLoaded)
                .userPosition
                .longitude,
          ),
        ),
      );
    }
  }

  Future<List<OSMObject>> searchOSMObjects(String searchTerm) async {
    final currentState = state;

    if (currentState is OsmDataCubitLoaded) {
      final allOSMObjects = [
        ...currentState.nodeMap.values,
        ...currentState.wayMap.values,
        ...currentState.relationMap.values,
      ];

      final searchResults = allOSMObjects.where((osmObject) {
        return osmObject.tags.keys.any(
              (key) => key.toLowerCase().contains(searchTerm.toLowerCase()),
            ) ||
            osmObject.tags.values.any(
              (value) => value
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()),
            );
      }).toList();

      return searchResults;
    } else {
      return [];
    }
  }

  Future loadInitialData() async {
    emit(const OsmDataCubitLoading());

    final UserPositionLoaded userPositionLoaded = await userPositionCubit.stream
            .firstWhere((state) => state is UserPositionLoaded)
        as UserPositionLoaded;

    final List<OSMObject> osmObjects =
        await _localOSMRepository.loadOSMObjects(filePath: "");

    final Map<int, Node> nodeMap = {};
    final Map<int, Way> wayMap = {};
    final Map<int, Relation> relationMap = {};

    osmObjects.whereType<Node>().forEach((element) {
      nodeMap[element.id] = element;
    });
    osmObjects.whereType<Way>().forEach((element) {
      wayMap[element.id] = element;
    });
    osmObjects.whereType<Relation>().forEach((element) {
      relationMap[element.id] = element;
    });

    emit(
      OsmDataCubitLoaded(
        nodeMap: nodeMap,
        wayMap: wayMap,
        relationMap: relationMap,
        radius: 10,
        center: LatLng(
          userPositionLoaded.userPosition.latitude,
          userPositionLoaded.userPosition.longitude,
        ),
      ),
    );
  }

  Future<void> fetchOSMObjects() async {
    final List<OSMObject> osmObjects = [];

    emit(
      OsmDataCubitSyncing(
        nodeMap: (state as OsmDataCubitLoaded).nodeMap,
        wayMap: (state as OsmDataCubitLoaded).wayMap,
        relationMap: (state as OsmDataCubitLoaded).relationMap,
        radius: (state as OsmDataCubitLoaded).radius,
        center: (state as OsmDataCubitLoaded).center,
        progress: 0,
        message: 'Fetching OSM objects',
        fetchedItems: 0,
      ),
    );

    final int countOfValuesInEmojiTagMap = emojiTagMapCubit
        .state.emojiTagMap.values
        .map((e) => e.length)
        .reduce((value, element) => value + element);

    int countOfFetchedTags = 0;

    for (final entry in emojiTagMapCubit.state.emojiTagMap.entries) {
      for (final value in entry.value.keys) {
        countOfFetchedTags++;
        try {
          emit(
            OsmDataCubitSyncing(
              nodeMap: (state as OsmDataCubitLoaded).nodeMap,
              wayMap: (state as OsmDataCubitLoaded).wayMap,
              relationMap: (state as OsmDataCubitLoaded).relationMap,
              radius: (state as OsmDataCubitLoaded).radius,
              center: (state as OsmDataCubitLoaded).center,
              progress: countOfFetchedTags / countOfValuesInEmojiTagMap,
              message: 'Fetching ${entry.key}=$value',
              fetchedItems: osmObjects.length,
            ),
          );
          final objects = await _overpassRepository.fetchOSMObjects(
            types: [OSMType.node, OSMType.way, OSMType.relation],
            latitude: userPositionCubit.state is UserPositionLoaded
                ? (userPositionCubit.state as UserPositionLoaded)
                    .userPosition
                    .latitude
                : 0,
            longitude: userPositionCubit.state is UserPositionLoaded
                ? (userPositionCubit.state as UserPositionLoaded)
                    .userPosition
                    .longitude
                : 0,
            radius: state is OsmDataCubitLoaded
                ? (state as OsmDataCubitLoaded).radius * 1000
                : 10 * 1000,
            tags: [
              {
                'key': entry.key,
                'value': value,
              },
            ],
          );

          osmObjects.addAll(objects);
          log('Fetched ${objects.length} objects');
          log('Total objects: ${osmObjects.length}');
        } catch (e) {
          log('Error fetching objects: $e');
          rethrow;
        }
      }
    }

    emit(
      OsmDataCubitSyncing(
        nodeMap: (state as OsmDataCubitLoaded).nodeMap,
        wayMap: (state as OsmDataCubitLoaded).wayMap,
        relationMap: (state as OsmDataCubitLoaded).relationMap,
        radius: (state as OsmDataCubitLoaded).radius,
        center: (state as OsmDataCubitLoaded).center,
        progress: 0,
        message: 'Fetched all OSM objects, saving to local storage',
        fetchedItems: osmObjects.length,
      ),
    );

    final Map<int, Node> nodeMap = {};
    final Map<int, Way> wayMap = {};
    final Map<int, Relation> relationMap = {};

    osmObjects.whereType<Node>().forEach((element) {
      nodeMap[element.id] = element;
    });
    osmObjects.whereType<Way>().forEach((element) {
      wayMap[element.id] = element;
    });
    osmObjects.whereType<Relation>().forEach((element) {
      relationMap[element.id] = element;
    });

    log('saving objects to local storage');
    await _localOSMRepository.saveOSMObjects(osmObjects);
    log('saved objects to local storage');
    final mergedNodeMap = {
      ...(state as OsmDataCubitLoaded).nodeMap,
      ...nodeMap,
    };
    final mergedWayMap = {
      ...(state as OsmDataCubitLoaded).wayMap,
      ...wayMap,
    };
    final mergedRelationMap = {
      ...(state as OsmDataCubitLoaded).relationMap,
      ...relationMap,
    };
    emit(
      OsmDataCubitLoaded(
        nodeMap: mergedNodeMap,
        wayMap: mergedWayMap,
        relationMap: mergedRelationMap,
        radius: state is OsmDataCubitLoaded
            ? (state as OsmDataCubitLoaded).radius
            : 10,
        center: LatLng(
          (userPositionCubit.state as UserPositionLoaded).userPosition.latitude,
          (userPositionCubit.state as UserPositionLoaded)
              .userPosition
              .longitude,
        ),
      ),
    );
  }
}
