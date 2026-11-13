import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/widzew_skin.dart';
import 'widzew_colors.dart';
import 'widzew_ui.dart';

class WidzewTheme {
  static Color systemNavigationBarColor({
    required Brightness brightness,
    required Color accent,
  }) {
    final ink = brightness == Brightness.dark
        ? const Color(0xFF050505)
        : const Color(0xFF1A1A1A);
    return Color.lerp(
      ink,
      accent,
      brightness == Brightness.dark ? 0.18 : 0.24,
    )!;
  }

  static SystemUiOverlayStyle overlayStyle({
    required Brightness brightness,
    required Color accent,
  }) {
    final navColor = systemNavigationBarColor(
      brightness: brightness,
      accent: accent,
    );
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: navColor,
      systemNavigationBarDividerColor: Color.lerp(navColor, Colors.white, 0.16),
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: true,
    );
  }

  static SystemUiOverlayStyle overlayStyleFor(ThemeData theme) {
    return overlayStyle(
      brightness: theme.brightness,
      accent: theme.colorScheme.primary,
    );
  }

  static ThemeData light({
    bool seniorMode = false,
    bool driverMode = false,
    WidzewSkin skin = WidzewSkin.classic,
    bool highContrast = false,
    bool readability = false,
  }) => _build(
    Brightness.light,
    seniorMode: seniorMode,
    driverMode: driverMode,
    skin: skin,
    highContrast: highContrast,
    readability: readability,
  );

  static ThemeData dark({
    bool seniorMode = false,
    bool driverMode = false,
    WidzewSkin skin = WidzewSkin.classic,
    bool highContrast = false,
    bool readability = false,
  }) => _build(
    Brightness.dark,
    seniorMode: seniorMode,
    driverMode: driverMode,
    skin: skin,
    highContrast: highContrast,
    readability: readability,
  );

  static ThemeData _build(
    Brightness brightness, {
    bool seniorMode = false,
    bool driverMode = false,
    WidzewSkin skin = WidzewSkin.classic,
    bool highContrast = false,
    bool readability = false,
  }) {
    final isDark = brightness == Brightness.dark;
    final accent = skin.seed;
    Color mixDark(double amount) =>
        Color.lerp(const Color(0xFF121212), accent, amount)!;
    var scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
    ).copyWith(primary: accent);
    if (isDark) {
      scheme = scheme.copyWith(surface: mixDark(0.14));
    }
    scheme = scheme.copyWith(
      onSurface: isDark ? WidzewColors.inkOnDark : WidzewColors.ink,
      onSurfaceVariant: isDark
          ? const Color(0xFFE0E0E0)
          : WidzewColors.inkMuted,
      onSecondaryContainer: isDark ? WidzewColors.inkOnDark : WidzewColors.ink,
      onTertiaryContainer: isDark ? WidzewColors.inkOnDark : WidzewColors.ink,
      secondaryContainer: isDark ? mixDark(0.22) : skin.soft,
    );
    if (highContrast) {
      scheme = scheme.copyWith(
        surface: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
        onSurface: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
      );
    }
    final largeType = seniorMode || driverMode || readability;
    final ink = isDark ? WidzewColors.inkOnDark : WidzewColors.ink;

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark
          ? (highContrast ? const Color(0xFF000000) : mixDark(0.08))
          : scheme.surface,
      visualDensity: largeType
          ? VisualDensity.comfortable
          : VisualDensity.standard,
      textTheme: _textTheme(brightness, largeType, extraLarge: driverMode),
      primaryTextTheme: _textTheme(
        brightness,
        largeType,
        extraLarge: driverMode,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: WidzewUi.shape,
          padding: WidzewUi.buttonPadding,
          minimumSize: driverMode ? const Size.fromHeight(56) : null,
          textStyle: driverMode ? const TextStyle(fontSize: 18) : null,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: WidzewUi.shape,
          padding: WidzewUi.buttonPadding,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: WidzewUi.shape,
          padding: WidzewUi.buttonPadding,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: WidzewUi.shape,
          padding: WidzewUi.buttonPadding,
        ),
      ),
      splashFactory: InkRipple.splashFactory,
      splashColor: accent.withValues(alpha: 0.14),
      highlightColor: accent.withValues(alpha: 0.06),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: WidzewUi.shape,
        splashColor: accent.withValues(alpha: 0.18),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: accent,
        foregroundColor: WidzewColors.white,
        elevation: 0,
        systemOverlayStyle: overlayStyle(
          brightness: brightness,
          accent: accent,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? mixDark(0.28) : null,
        contentTextStyle: TextStyle(
          color: isDark ? WidzewColors.inkOnDark : null,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? mixDark(0.16) : scheme.surface,
        shape: WidzewUi.shape,
        surfaceTintColor: Colors.transparent,
      ),
      chipTheme: ChipThemeData(
        shape: WidzewUi.shape,
        backgroundColor: isDark ? mixDark(0.22) : WidzewColors.chipFill,
        selectedColor: isDark ? accent.withValues(alpha: 0.45) : skin.soft,
        surfaceTintColor: Colors.transparent,
        labelStyle: TextStyle(
          color: ink,
          fontWeight: FontWeight.w600,
          height: 1.2,
          overflow: TextOverflow.visible,
        ),
        secondaryLabelStyle: TextStyle(color: ink, fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(color: ink, size: 18),
        deleteIconColor: ink,
        checkmarkColor: isDark ? WidzewColors.inkOnDark : WidzewColors.ink,
      ),
      dialogTheme: DialogThemeData(
        shape: WidzewUi.shape,
        backgroundColor: isDark ? mixDark(0.16) : WidzewColors.white,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(color: ink, fontSize: 16, height: 1.35),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        textColor: ink,
        iconColor: ink,
        subtitleTextStyle: TextStyle(
          color: isDark ? const Color(0xFFE0E0E0) : WidzewColors.inkMuted,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(WidzewUi.shape),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(color: ink, overflow: TextOverflow.visible),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: isDark,
        fillColor: isDark ? mixDark(0.18) : null,
        labelStyle: TextStyle(
          color: isDark ? const Color(0xFFE0E0E0) : WidzewColors.inkMuted,
        ),
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFFBDBDBD) : WidzewColors.grey,
        ),
        border: OutlineInputBorder(borderRadius: WidzewUi.borderRadius),
        enabledBorder: OutlineInputBorder(borderRadius: WidzewUi.borderRadius),
        focusedBorder: OutlineInputBorder(borderRadius: WidzewUi.borderRadius),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? mixDark(0.10) : scheme.surface,
        indicatorColor: isDark ? accent.withValues(alpha: 0.28) : skin.soft,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: accent);
          }
          return IconThemeData(
            color: isDark ? const Color(0xFFE0E0E0) : WidzewColors.grey,
          );
        }),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _textTheme(
    Brightness brightness,
    bool large, {
    bool extraLarge = false,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
    ).textTheme;
    final color = brightness == Brightness.dark
        ? WidzewColors.inkOnDark
        : WidzewColors.ink;
    var themed = base.apply(bodyColor: color, displayColor: color);
    if (!large) return themed;
    final bump = extraLarge ? 4.0 : 0.0;
    return themed.copyWith(
      bodyLarge: themed.bodyLarge?.copyWith(fontSize: 18 + bump, height: 1.35),
      bodyMedium: themed.bodyMedium?.copyWith(
        fontSize: 16 + bump,
        height: 1.35,
      ),
      titleMedium: themed.titleMedium?.copyWith(fontSize: 20 + bump),
      titleLarge: themed.titleLarge?.copyWith(fontSize: 24 + bump),
      labelLarge: themed.labelLarge?.copyWith(fontSize: 16 + bump),
    );
  }
}
