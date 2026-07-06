import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Derives a stable avatar color from a person's [colorSeed] against the
/// current [ColorScheme], so avatars look at home in both light and dark mode.
class AvatarColor {
  const AvatarColor._();

  static Color forSeed(int colorSeed, ColorScheme scheme) {
    final hue = (colorSeed % AppConstants.avatarColorCount) *
        (360 / AppConstants.avatarColorCount);
    final saturation = scheme.brightness == Brightness.dark ? 0.45 : 0.55;
    final lightness = scheme.brightness == Brightness.dark ? 0.55 : 0.62;
    return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
  }

  /// The avatar label: the first letter of the name (uppercased, or `?` when
  /// blank) with the person's [id] appended so people who share an initial —
  /// e.g. two "A" names — stay visually distinct. A null [id] (an unsaved
  /// person) yields just the letter.
  static String label(String name, int? id) {
    final trimmed = name.trim();
    final letter =
        trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase();
    return id == null ? letter : '$letter$id';
  }
}
