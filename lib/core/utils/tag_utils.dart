// ignore_for_file: avoid_classes_with_only_static_members

abstract class TagUtils {
  static Map<String, dynamic> flattenTags(Map<String, dynamic> nestedTags) {
    final flattenedTags = <String, dynamic>{};
    _flattenTagsRecursive(flattenedTags, nestedTags, '');
    return flattenedTags;
  }

  static void _flattenTagsRecursive(
    Map<String, dynamic> flattenedTags,
    Map<String, dynamic> nestedTags,
    String prefix,
  ) {
    nestedTags.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        _flattenTagsRecursive(flattenedTags, value, '$prefix$key:');
      } else {
        flattenedTags['$prefix$key'] = value;
      }
    });
  }

  static Map<String, dynamic> expandTags(
    Map<String, dynamic> flattenedTags,
  ) {
    final nestedTags = <String, dynamic>{};
    flattenedTags.forEach((key, value) {
      final keys = key.split(':');
      var currentMap = nestedTags;

      for (var i = 0; i < keys.length - 1; i++) {
        if (currentMap[keys[i]] is! Map<String, dynamic>) {
          currentMap[keys[i]] = <String, dynamic>{};
        }
        currentMap = currentMap[keys[i]] as Map<String, dynamic>;
      }

      currentMap[keys.last] = value;
    });

    return nestedTags;
  }
}
