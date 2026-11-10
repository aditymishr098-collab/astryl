import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

/// Astryl's Clean Minimal Deep-Space colour palette:
/// Soft Starlight Blue (#5B9BFF), Matte Charcoal Slate (#10141F), and
/// Deep Space Black (#06080E) inspired by Apple Astronomy & NASA.
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

  /// Soft Starlight Blue, for filled buttons, active tabs and clean highlights.
  final Color accent;
  final Color onAccent;

  /// Soft Starlight Blue readable as text on [background].
  final Color accentText;

  /// Soft celestial blue-slate for orbital accents.
  final Color orbit;
  final Color orbitLine;
  final Color good;
  final Color bad;
  final Color star;

  static const Palette dark = Palette(
    background: Color(0xFF06080E),
    surface: Color(0xFF10141F),
    surfaceHigh: Color(0xFF171D2B),
    border: Color(0xFF222A3D),
    text: Color(0xFFF3F6FC),
    muted: Color(0xFF8C9BB5),
    accent: Color(0xFF5B9BFF),
    onAccent: Color(0xFF060A12),
    accentText: Color(0xFF7DB0FF),
    orbit: Color(0xFF6B8AFD),
    orbitLine: Color(0xFF232C40),
    good: Color(0xFF34D399),
    bad: Color(0xFFF87171),
    star: Color(0xFFFBBF24),
  );

  static const Palette light = Palette(
    background: Color(0xFFF4F6FA),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFE9EEF6),
    border: Color(0xFFD5DFEE),
    text: Color(0xFF0D1321),
    muted: Color(0xFF56657F),
    accent: Color(0xFF2B6CB0),
    onAccent: Color(0xFFFFFFFF),
    accentText: Color(0xFF2563EB),
    orbit: Color(0xFF3B82F6),
    orbitLine: Color(0xFFCBD5E1),
    good: Color(0xFF059669),
    bad: Color(0xFFDC2626),
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

/// The clock, the signal and the battery in the phone's status bar. On a light
/// theme they must be dark, on a dark theme light. Without this, a transparent
/// app bar makes Flutter think the bar is dark and the icons turn white on a
/// white page.
SystemUiOverlayStyle statusBarStyle(Brightness brightness) {
  final light = brightness == Brightness.light;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: light ? Brightness.dark : Brightness.light,
    statusBarBrightness: light ? Brightness.light : Brightness.dark,
  );
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
      systemOverlayStyle: statusBarStyle(brightness),
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
