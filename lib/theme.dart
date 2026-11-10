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

/// Astryl's colours: Cosmic Nebula dark ("deep space") and a crisp light theme.
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
    background: Color(0xFF060A17),
    surface: Color(0xFF10172E),
    surfaceHigh: Color(0xFF182242),
    border: Color(0xFF283660),
    text: Color(0xFFF0F4FF),
    muted: Color(0xFF98A6C8),
    accent: Color(0xFFFFB02E),
    onAccent: Color(0xFF060A17),
    accentText: Color(0xFFFFB83D),
    orbit: Color(0xFF6EA8FF),
    orbitLine: Color(0xFF26335A),
    good: Color(0xFF6CE59B),
    bad: Color(0xFFFF8F70),
    star: Color(0xFF6B7BA8),
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
  final isDark = brightness == Brightness.dark;
  final p = isDark ? Palette.dark : Palette.light;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.accent,
    onPrimary: p.onAccent,
    secondary: p.orbit,
    onSecondary: isDark ? p.background : Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        textStyle: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.text,
        side: BorderSide(color: p.border, width: 1.3),
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
          ? const Color(0xFF0B1124).withValues(alpha: 0.85)
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
          ? const Color(0xFF0D1429).withValues(alpha: 0.94)
          : Colors.white.withValues(alpha: 0.95),
      indicatorColor: p.accent.withValues(alpha: isDark ? 0.18 : 0.22),
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
