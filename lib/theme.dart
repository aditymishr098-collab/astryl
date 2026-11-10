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

/// Astryl's Neon Cyber-Space colour palette:
/// Electric Aurora Cyan (#00F0FF), Cosmic Violet (#9D4EDD), Solar Gold (#FFB800),
/// and True AMOLED Deep Void (#040611).
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

  /// Electric Aurora Cyan, for filled buttons, neon highlights and active states.
  final Color accent;
  final Color onAccent;

  /// Electric Cyan readable as text on [background].
  final Color accentText;

  /// Cosmic Violet for secondary neon gradients and orbital highlights.
  final Color orbit;
  final Color orbitLine;
  final Color good;
  final Color bad;
  final Color star;

  static const Palette dark = Palette(
    background: Color(0xFF040611),
    surface: Color(0xFF0C1226),
    surfaceHigh: Color(0xFF151E3D),
    border: Color(0xFF25386B),
    text: Color(0xFFF2F7FF),
    muted: Color(0xFF8EA4D2),
    accent: Color(0xFF00E5FF),
    onAccent: Color(0xFF030712),
    accentText: Color(0xFF26F0FF),
    orbit: Color(0xFFA855F7),
    orbitLine: Color(0xFF233463),
    good: Color(0xFF00F59B),
    bad: Color(0xFFFF5E7E),
    star: Color(0xFFFFB800),
  );

  static const Palette light = Palette(
    background: Color(0xFFF2F6FC),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFE5EEFA),
    border: Color(0xFFD0DEF2),
    text: Color(0xFF0B132B),
    muted: Color(0xFF4F628E),
    accent: Color(0xFF0099CC),
    onAccent: Color(0xFFFFFFFF),
    accentText: Color(0xFF0077AA),
    orbit: Color(0xFF7E22CE),
    orbitLine: Color(0xFFC7D7EE),
    good: Color(0xFF0D9488),
    bad: Color(0xFFE11D48),
    star: Color(0xFFD97706),
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
  final isDark = brightness == Brightness.dark;
  final p = isDark ? Palette.dark : Palette.light;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.accent,
    onPrimary: p.onAccent,
    secondary: p.orbit,
    onSecondary: Colors.white,
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
      backgroundColor: Colors.transparent,
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
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        textStyle: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.text,
        side: BorderSide(color: p.accent.withValues(alpha: 0.45), width: 1.3),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark
          ? const Color(0xFF080D1F).withValues(alpha: 0.9)
          : p.surfaceHigh.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: p.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: p.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: p.accent, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: p.bad),
      ),
      labelStyle: TextStyle(color: p.muted),
      helperStyle: TextStyle(color: p.muted, fontSize: 12),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      backgroundColor: isDark
          ? const Color(0xFF090E22).withValues(alpha: 0.95)
          : Colors.white.withValues(alpha: 0.95),
      indicatorColor: p.accent.withValues(alpha: isDark ? 0.2 : 0.22),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11.5,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? p.accentText : p.muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
            size: 24, color: selected ? p.accentText : p.muted);
      }),
    ),
    dividerTheme: DividerThemeData(color: p.border, space: 1),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: p.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      contentTextStyle: TextStyle(color: p.text, fontWeight: FontWeight.w500),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: p.border),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? p.onAccent : p.muted),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? p.accent : p.surfaceHigh),
    ),
  );
}
