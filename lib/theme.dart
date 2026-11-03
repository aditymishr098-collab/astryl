import 'package:flutter/material.dart';

/// The font for titles and big numbers. Everything else uses DM Sans. Both
/// are bundled in the app (assets/fonts), so nothing is downloaded.
const String headingFont = 'SpaceGrotesk';
const String bodyFont = 'DMSans';

/// A heading in Space Grotesk.
TextStyle headingStyle(double size, Color color,
        {FontWeight weight = FontWeight.w700, double? height}) =>
    TextStyle(
      fontFamily: headingFont,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );

/// Heliora's colours, from the approved design (dark "deep space" and a
/// light cream theme).
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.border,
    required this.text,
    required this.muted,
    required this.accent,
    required this.onAccent,
    required this.accentText,
    required this.orbit,
    required this.orbitLine,
    required this.good,
    required this.bad,
    required this.star,
  });

  final Color background;
  final Color surface;
  final Color surfaceHigh;
  final Color border;
  final Color text;
  final Color muted;

  /// Sol amber, for filled buttons and highlights.
  final Color accent;
  final Color onAccent;

  /// Amber that is readable as text on [background].
  final Color accentText;
  final Color orbit;
  final Color orbitLine;
  final Color good;
  final Color bad;
  final Color star;

  static const Palette dark = Palette(
    background: Color(0xFF0B1020),
    surface: Color(0xFF141B33),
    surfaceHigh: Color(0xFF1C2547),
    border: Color(0xFF2A3458),
    text: Color(0xFFE8ECF8),
    muted: Color(0xFF9AA6C4),
    accent: Color(0xFFF5A524),
    onAccent: Color(0xFF0B1020),
    accentText: Color(0xFFF5A524),
    orbit: Color(0xFF7AA2FF),
    orbitLine: Color(0xFF2A3458),
    good: Color(0xFF8FE3A6),
    bad: Color(0xFFFFB08A),
    star: Color(0xFF5C6890),
  );

  static const Palette light = Palette(
    background: Color(0xFFF6F4EF),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFEFEBE2),
    border: Color(0xFFE4E0D6),
    text: Color(0xFF141B33),
    muted: Color(0xFF5A6480),
    accent: Color(0xFFF5A524),
    onAccent: Color(0xFF141B33),
    accentText: Color(0xFFA85F00),
    orbit: Color(0xFF3554C8),
    orbitLine: Color(0xFFDCD7CB),
    good: Color(0xFF1E7A3E),
    bad: Color(0xFFB3401A),
    star: Color(0x00000000),
  );

  static Palette of(BuildContext context) =>
      Theme.of(context).extension<Palette>() ?? dark;

  @override
  Palette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceHigh,
    Color? border,
    Color? text,
    Color? muted,
    Color? accent,
    Color? onAccent,
    Color? accentText,
    Color? orbit,
    Color? orbitLine,
    Color? good,
    Color? bad,
    Color? star,
  }) {
    return Palette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      border: border ?? this.border,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentText: accentText ?? this.accentText,
      orbit: orbit ?? this.orbit,
      orbitLine: orbitLine ?? this.orbitLine,
      good: good ?? this.good,
      bad: bad ?? this.bad,
      star: star ?? this.star,
    );
  }

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) {
    if (other is! Palette) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return Palette(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceHigh: mix(surfaceHigh, other.surfaceHigh),
      border: mix(border, other.border),
      text: mix(text, other.text),
      muted: mix(muted, other.muted),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      accentText: mix(accentText, other.accentText),
      orbit: mix(orbit, other.orbit),
      orbitLine: mix(orbitLine, other.orbitLine),
      good: mix(good, other.good),
      bad: mix(bad, other.bad),
      star: mix(star, other.star),
    );
  }
}

ThemeData buildTheme(Brightness brightness) {
  final p = brightness == Brightness.dark ? Palette.dark : Palette.light;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.accent,
    onPrimary: p.onAccent,
    secondary: p.orbit,
    onSecondary: brightness == Brightness.dark ? p.background : Colors.white,
    error: p.bad,
    onError: p.background,
    surface: p.background,
    onSurface: p.text,
    surfaceContainerHighest: p.surfaceHigh,
    outline: p.border,
  );
  return ThemeData(
    useMaterial3: true,
    fontFamily: bodyFont,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.background,
    extensions: <ThemeExtension<dynamic>>[p],
    appBarTheme: AppBarTheme(
      backgroundColor: p.background,
      foregroundColor: p.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: headingStyle(22, p.text),
    ),
    cardTheme: CardThemeData(
      color: p.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: p.border),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: brightness == Brightness.dark
          ? const Color(0xFF0E1428)
          : Colors.white,
      indicatorColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? p.accentText : p.muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
            size: 26, color: selected ? p.accentText : p.muted);
      }),
    ),
    dividerTheme: DividerThemeData(color: p.border, space: 1),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: p.surfaceHigh,
      contentTextStyle: TextStyle(color: p.text),
    ),
    dialogTheme: DialogThemeData(backgroundColor: p.surface),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? p.onAccent : p.muted),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? p.accent : p.surfaceHigh),
    ),
  );
}
