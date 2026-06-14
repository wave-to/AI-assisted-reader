import 'package:ai_assisted_reader/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reading_theme.g.dart';

/// 阅读主题状态管理
/// 控制系统 UI 风格和阅读区双主题切换

@Riverpod(keepAlive: true)
class ReadingTheme extends _$ReadingTheme {
  @override
  ReadingThemeMode build() {
    // 默认使用纸墨风格
    return ReadingThemeMode.paper;
  }

  /// 切换阅读主题
  void setMode(ReadingThemeMode mode) {
    state = mode;
  }

  /// 获取当前阅读主题的背景色
  Color backgroundColor(Brightness brightness) {
    return switch (state) {
      ReadingThemeMode.minimal => brightness == Brightness.light
          ? MinimalReaderColors.background
          : MinimalReaderColors.darkBackground,
      ReadingThemeMode.paper => brightness == Brightness.light
          ? PaperColors.background
          : PaperColors.darkBackground,
    };
  }

  /// 获取当前阅读主题的文字色
  Color textColor(Brightness brightness) {
    return switch (state) {
      ReadingThemeMode.minimal => brightness == Brightness.light
          ? MinimalReaderColors.textPrimary
          : MinimalReaderColors.darkTextPrimary,
      ReadingThemeMode.paper => brightness == Brightness.light
          ? PaperColors.textPrimary
          : PaperColors.darkTextPrimary,
    };
  }

  /// 获取当前阅读主题的强调色
  Color accentColor(Brightness brightness) {
    return switch (state) {
      ReadingThemeMode.minimal => brightness == Brightness.light
          ? MinimalReaderColors.accent
          : MinimalReaderColors.darkAccent,
      ReadingThemeMode.paper => brightness == Brightness.light
          ? PaperColors.accent
          : PaperColors.darkAccent,
    };
  }

  /// 获取当前阅读主题的高亮色
  Color highlightColor(Brightness brightness) {
    return switch (state) {
      ReadingThemeMode.minimal => brightness == Brightness.light
          ? MinimalReaderColors.highlight
          : MinimalReaderColors.darkHighlight,
      ReadingThemeMode.paper => brightness == Brightness.light
          ? PaperColors.highlight
          : PaperColors.darkHighlight,
    };
  }

  /// 获取阅读主题的 hex 背景色（用于 ReadTheme 数据库存储）
  String backgroundColorHex(Brightness brightness) {
    return ReadingThemePresets.backgroundColor(state, brightness);
  }

  /// 获取阅读主题的 hex 文字色（用于 ReadTheme 数据库存储）
  String textColorHex(Brightness brightness) {
    return ReadingThemePresets.textColor(state, brightness);
  }
}
