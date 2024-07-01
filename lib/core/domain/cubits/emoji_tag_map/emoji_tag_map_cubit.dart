// ignore_for_file: prefer_const_constructors

import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
@singleton
class EmojiTagMapCubit extends Cubit<EmojiTagState> {
  EmojiTagMapCubit() : super(const EmojiTagState(emojiTagMap: {})) {
    loadEmojiTagMap();
  }

  loadEmojiTagMap() {
    emit(
      EmojiTagState(
        emojiTagMap: {
          'amenity': {
            'restaurant': {'emoji': '🍽️', 'visible': false},
            'cafe': {'emoji': '☕', 'visible': false},
            'bank': {'emoji': '🏦', 'visible': false},
            'fast_food': {'emoji': '🍔', 'visible': false},
            'parking': {'emoji': '🅿️', 'visible': false},
            'fuel': {'emoji': '⛽', 'visible': false},
            'hospital': {'emoji': '🏥', 'visible': false},
            'pharmacy': {'emoji': '💊', 'visible': false},
            'school': {'emoji': '🏫', 'visible': false},
            'library': {'emoji': '📚', 'visible': false},
            'police': {'emoji': '🚓', 'visible': false},
            'post_office': {'emoji': '📮', 'visible': false},
            'bar': {'emoji': '🍸', 'visible': false},
            'pub': {'emoji': '🍺', 'visible': false},
            'atm': {'emoji': '💰', 'visible': false},
            'toilets': {'emoji': '🚻', 'visible': false},
            'cinema': {'emoji': '🎬', 'visible': false},
            'theatre': {'emoji': '🎭', 'visible': false},
            'gym': {'emoji': '🏋️', 'visible': false},
            'place_of_worship': {'emoji': '🛐', 'visible': false},
            'fire_station': {'emoji': '🚒', 'visible': false},
            'doctors': {'emoji': '🩺', 'visible': false},
            'bench': {'emoji': '🪑', 'visible': false},
          },
          'shop': {
            'supermarket': {'emoji': '🛒', 'visible': false},
            'bakery': {'emoji': '🥖', 'visible': false},
            'clothes': {'emoji': '👕', 'visible': false},
            'convenience': {'emoji': '🏪', 'visible': false},
            'hairdresser': {'emoji': '💇', 'visible': false},
            'beauty': {'emoji': '💅', 'visible': false},
            'kiosk': {'emoji': '📰', 'visible': false},
            'hardware': {'emoji': '🔨', 'visible': false},
            'butcher': {'emoji': '🥩', 'visible': false},
            'mobile_phone': {'emoji': '📱', 'visible': false},
            'furniture': {'emoji': '🪑', 'visible': false},
            'car_parts': {'emoji': '🔧', 'visible': false},
            'alcohol': {'emoji': '🍷', 'visible': false},
            'florist': {'emoji': '💐', 'visible': false},
            'electronics': {'emoji': '📱', 'visible': false},
            'car': {'emoji': '🚗', 'visible': false},
            'car_repair': {'emoji': '🔧', 'visible': false},
          },
          'tourism': {
            'information': {'emoji': 'ℹ️', 'visible': false},
            'hotel': {'emoji': '🏨', 'visible': false},
            'artwork': {'emoji': '🖼️', 'visible': false},
            'attraction': {'emoji': '🎢', 'visible': false},
            'viewpoint': {'emoji': '🏞️', 'visible': false},
            'guest_house': {'emoji': '🏠', 'visible': false},
            'picnic_site': {'emoji': '🧺', 'visible': false},
            'camp_site': {'emoji': '⛺', 'visible': false},
            'museum': {'emoji': '🏛️', 'visible': false},
            'chalet': {'emoji': '🏡', 'visible': false},
            'camp_pitch': {'emoji': '🏕️', 'visible': false},
            'apartment': {'emoji': '🏢', 'visible': false},
            'hostel': {'emoji': '🏘️', 'visible': false},
            'motel': {'emoji': '🏩', 'visible': false},
            'caravan_site': {'emoji': '🚐', 'visible': false},
            'gallery': {'emoji': '🖼️', 'visible': false},
          },
          'leisure': {
            'playground': {'emoji': '🪁', 'visible': false},
            'sports_centre': {'emoji': '🏟️', 'visible': false},
            'swimming_pool': {'emoji': '🏊', 'visible': false},
            'fitness_centre': {'emoji': '🏋️', 'visible': false},
            'park': {'emoji': '🌳', 'visible': false},
            'garden': {'emoji': '🌷', 'visible': false},
            'pitch': {'emoji': '⚽', 'visible': false},
            'track': {'emoji': '🏃', 'visible': false},
            'stadium': {'emoji': '🏟️', 'visible': false},
            'nature_reserve': {'emoji': '🌲', 'visible': false},
            'dog_park': {'emoji': '🐕', 'visible': false},
            'fitness_station': {'emoji': '🏋️', 'visible': false},
            'ice_rink': {'emoji': '⛸️', 'visible': false},
            'miniature_golf': {'emoji': '⛳', 'visible': false},
            'water_park': {'emoji': '🏊', 'visible': false},
            'common': {'emoji': '🌳', 'visible': false},
            'slipway': {'emoji': '🚤', 'visible': false},
            'marina': {'emoji': '⛵', 'visible': false},
            'fishing': {'emoji': '🎣', 'visible': false},
            'bird_hide': {'emoji': '🦜', 'visible': false},
            'wildlife_hide': {'emoji': '🦜', 'visible': false},
            'bird_watching': {'emoji': '🦜', 'visible': false},
            'wildlife_watching': {'emoji': '🦜', 'visible': false},
            'firepit': {'emoji': '🔥', 'visible': false},
            'outdoor_seating': {'emoji': '🪑', 'visible': false},
            'picnic_table': {'emoji': '🧺', 'visible': false},
          },
          "public_transport": {
            "platform": {"emoji": "🚉", "visible": false},
            "station": {"emoji": "🚉", "visible": false},
          },
          "emergency": {
            "phone": {"emoji": "🚑", "visible": false},
            "fire_hydrant": {"emoji": "🚒", "visible": false},
            "defibrillator": {"emoji": "🩺", "visible": false},
          },
          "man_made": {
            "tower": {"emoji": "🗼", "visible": false},
            "water_tower": {"emoji": "🗼", "visible": false},
            "windmill": {"emoji": "⛰️", "visible": false},
            "lighthouse": {"emoji": "🏠", "visible": false},
            "surveillance": {"emoji": "🎦", "visible": false},
            "survey_point": {"emoji": "📍", "visible": false},
          },
          "military": {
            "bunker": {"emoji": "🏚️", "visible": false},
            "barracks": {"emoji": "🏚️", "visible": false},
            "checkpoint": {"emoji": "🚧", "visible": false},
            "danger_area": {"emoji": "🚧", "visible": false},
            "naval_base": {"emoji": "⚓", "visible": false},
            "range": {"emoji": "🎯", "visible": false},
            "training_area": {"emoji": "🎯", "visible": false},
            "airfield": {"emoji": "✈️", "visible": false},
            "nuclear_explosion_site": {"emoji": "☢️", "visible": false},
            "obstacle_course": {"emoji": "🏃", "visible": false},
            "office": {"emoji": "🏢", "visible": false},
            "parade_ground": {"emoji": "🏟️", "visible": false},
            "storage": {"emoji": "🏢", "visible": false},
            "trench": {"emoji": "🏚️", "visible": false},
            "watchtower": {"emoji": "🏚️", "visible": false},
          },
        },
      ),
    );
  }

  void toggleVisibility({
    required String tagKey,
    String? tagValue,
  }) {
    final Map<String, Map<String, dynamic>> newEmojiTagMap =
        Map<String, Map<String, dynamic>>.from(state.emojiTagMap);

    if (tagValue != null) {
      if (newEmojiTagMap[tagKey]![tagValue]!['visible'] == true) {
        newEmojiTagMap[tagKey]![tagValue]!['visible'] = false;
      } else {
        newEmojiTagMap[tagKey]![tagValue]!['visible'] = true;
      }
    } else {
      final bool allVisible = newEmojiTagMap[tagKey]!
          .values
          .every((element) => element['visible'] == true);

      newEmojiTagMap[tagKey]!.forEach((key, value) {
        newEmojiTagMap[tagKey]![key]!['visible'] = !allVisible;
      });
    }

    emit(EmojiTagState(emojiTagMap: newEmojiTagMap));
  }
}
