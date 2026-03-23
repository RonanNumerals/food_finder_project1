import 'package:flutter/material.dart';

/// Centralised light and dark themes for the Munchies app.
///
/// Custom extension colours (chip fill, active filter, etc.) are exposed via
/// [AppThemeExtension] so that screens can access them through
/// `Theme.of(context).extension<AppThemeExtension>()`.
class AppTheme {
  AppTheme._();

  // ── Shared constants ─────────────────────────────────────────────────────
  static const Color _seedGreen = Colors.green;
  static const double _inputRadius = 30;

  // ── Light theme ──────────────────────────────────────────────────────────
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: _seedGreen,
          brightness: Brightness.light,
        ).copyWith(
          surface: Colors.white,
          onSurface: Colors.black,
          surfaceContainerHighest: const Color(0xFFECECEC),
          onSurfaceVariant: Colors.grey,
          primary: _seedGreen,
        ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: _seedGreen.withValues(alpha: 0.15),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFECECEC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputRadius),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        disabledForegroundColor: Colors.grey[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFE0E0E0)),
    extensions: const <ThemeExtension<dynamic>>[
      AppThemeExtension(
        chipFill: Color(0xFFECECEC),
        chipText: Colors.black,
        activeChipFill: _seedGreen,
        activeChipText: Colors.white,
        cardFill: Color(0xFFECECEC),
        subtitleText: Colors.grey,
        starEmpty: Colors.grey,
        priceText: _seedGreen,
      ),
    ],
  );

  // ── Dark theme ───────────────────────────────────────────────────────────
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: _seedGreen,
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF121212),
          onSurface: Colors.white,
          surfaceContainerHighest: const Color(0xFF2C2C2C),
          onSurfaceVariant: Colors.grey[400],
          primary: _seedGreen,
        ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: _seedGreen.withValues(alpha: 0.25),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputRadius),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        disabledBackgroundColor: Colors.grey[800],
        disabledForegroundColor: Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF3A3A3A)),
    extensions: const <ThemeExtension<dynamic>>[
      AppThemeExtension(
        chipFill: Color(0xFF2C2C2C),
        chipText: Colors.white,
        activeChipFill: _seedGreen,
        activeChipText: Colors.white,
        cardFill: Color(0xFF2C2C2C),
        subtitleText: Color(0xFF9E9E9E),
        starEmpty: Color(0xFF757575),
        priceText: _seedGreen,
      ),
    ],
  );
}

/// Custom colour slots that don't map cleanly to Material's [ColorScheme].
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.chipFill,
    required this.chipText,
    required this.activeChipFill,
    required this.activeChipText,
    required this.cardFill,
    required this.subtitleText,
    required this.starEmpty,
    required this.priceText,
  });

  final Color chipFill;
  final Color chipText;
  final Color activeChipFill;
  final Color activeChipText;
  final Color cardFill;
  final Color subtitleText;
  final Color starEmpty;
  final Color priceText;

  @override
  AppThemeExtension copyWith({
    Color? chipFill,
    Color? chipText,
    Color? activeChipFill,
    Color? activeChipText,
    Color? cardFill,
    Color? subtitleText,
    Color? starEmpty,
    Color? priceText,
  }) {
    return AppThemeExtension(
      chipFill: chipFill ?? this.chipFill,
      chipText: chipText ?? this.chipText,
      activeChipFill: activeChipFill ?? this.activeChipFill,
      activeChipText: activeChipText ?? this.activeChipText,
      cardFill: cardFill ?? this.cardFill,
      subtitleText: subtitleText ?? this.subtitleText,
      starEmpty: starEmpty ?? this.starEmpty,
      priceText: priceText ?? this.priceText,
    );
  }

  @override
  AppThemeExtension lerp(covariant AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      chipFill: Color.lerp(chipFill, other.chipFill, t)!,
      chipText: Color.lerp(chipText, other.chipText, t)!,
      activeChipFill: Color.lerp(activeChipFill, other.activeChipFill, t)!,
      activeChipText: Color.lerp(activeChipText, other.activeChipText, t)!,
      cardFill: Color.lerp(cardFill, other.cardFill, t)!,
      subtitleText: Color.lerp(subtitleText, other.subtitleText, t)!,
      starEmpty: Color.lerp(starEmpty, other.starEmpty, t)!,
      priceText: Color.lerp(priceText, other.priceText, t)!,
    );
  }
}
