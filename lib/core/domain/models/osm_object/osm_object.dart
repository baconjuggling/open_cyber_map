abstract class OSMObject {
  const OSMObject({required this.id, required this.tags});
  final int id;
  final Map<String, dynamic> tags;

  String get route => '/${runtimeType.toString().toLowerCase()}/$id';
  String get label =>
      tags['name']?.toString() ?? tags['brand']?.toString() ?? id.toString();

  bool containsTagWithKey(String key) {
    return tags.containsKey(key);
  }
}
