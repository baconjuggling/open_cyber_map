extension TagFormatToTitleCase on String {
  String get tagFormatToTitleCase {
    return split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
