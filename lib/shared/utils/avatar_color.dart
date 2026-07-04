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

  /// Two initials derived from a name, for the avatar label.
  static String initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
