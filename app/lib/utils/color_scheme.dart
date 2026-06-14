import 'package:ai_assisted_reader/config/shared_preference_provider.dart';
import 'package:ai_assisted_reader/theme/theme_constants.dart';
import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// BookReader 系统 UI 主题
/// 基于 UI/UX Pro Max — Minimalism & Swiss Style
ThemeData colorSchema(
  Prefs prefsNotifier,
  BuildContext context,
  Brightness brightness,
) {
  brightness = prefsNotifier.eInkMode
      ? Brightness.light
      : switch (prefsNotifier.themeMode) {
          ThemeMode.light => Brightness.light,
          ThemeMode.dark => Brightness.dark,
          ThemeMode.system => MediaQuery.platformBrightnessOf(context),
        };
  Color seedColor = prefsNotifier.themeColor;
  final isDark = brightness == Brightness.dark;
  final isEinkMode = prefsNotifier.eInkMode;

  // Swiss Minimal 系统背景色
  final lightGropedBackground = SwissColors.background;
  final darkGropedBackground =
      prefsNotifier.trueDarkMode ? SwissColors.darkBackground : const Color(0xFF1C1C1E);
  final gropedBackgroundColor = isEinkMode
      ? Colors.white
      : isDark
          ? darkGropedBackground
          : lightGropedBackground;

  final colorScheme = isEinkMode
      ? const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          primaryContainer: Colors.grey,
          onPrimaryContainer: Colors.black,
          secondary: Colors.grey,
          onSecondary: Colors.white,
          secondaryContainer: Colors.black12,
          onSecondaryContainer: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        )
      : switch (brightness) {
          Brightness.light => ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.light,
              surfaceContainer: SwissColors.surface,
              surface: lightGropedBackground,
            ),
          Brightness.dark => ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.dark,
              surfaceContainer: SwissColors.darkSurface,
              surface: darkGropedBackground,
            ),
        };

  ThemeData themeData = isEinkMode
      ? FlexThemeData.light(
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          colorScheme: colorScheme)
      : switch (brightness) {
          Brightness.light => FlexThemeData.light(
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              colorScheme: colorScheme,
            ),
          Brightness.dark => FlexThemeData.dark(
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              darkIsTrueBlack: prefsNotifier.trueDarkMode,
              colorScheme: colorScheme,
            )
        };

  return themeData
      .copyWith(
          sliderTheme: const SliderThemeData(year2023: false),
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(year2023: false),
          scaffoldBackgroundColor: gropedBackgroundColor,
          // Swiss Minimal: 卡片默认无阴影、小圆角
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: SwissColors.border),
            ),
            color: SwissColors.surface,
          ),
          bottomSheetTheme: BottomSheetThemeData()
              .copyWith(backgroundColor: gropedBackgroundColor),
          drawerTheme: DrawerThemeData()
              .copyWith(backgroundColor: gropedBackgroundColor),
          dialogTheme: DialogThemeData()
              .copyWith(backgroundColor: gropedBackgroundColor))
      .useSystemChineseFont(brightness);
}
