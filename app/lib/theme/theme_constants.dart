import 'package:flutter/material.dart';

/// BookReader 设计系统色彩常量
/// 来源: UI/UX Pro Max 设计引擎 + 设计系统方案 v2

// ============================================================
// 系统 UI — Minimalism & Swiss Style (始终应用)
// ============================================================

class SwissColors {
  SwissColors._();

  // 亮色
  static const background = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF737373);
  static const accent = Color(0xFF2563EB); // Blue-600
  static const accentLight = Color(0xFF3B82F6); // Blue-500
  static const border = Color(0xFFE5E5E5);
  static const highlight = Color(0xFFBFDBFE); // Blue-200
  static const error = Color(0xFFDC2626);
  static const success = Color(0xFF16A34A);

  // 暗色
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFE8E8E8);
  static const darkTextSecondary = Color(0xFF9CA3AF);
  static const darkAccent = Color(0xFF60A5FA); // Blue-400
  static const darkBorder = Color(0xFF2E2E2E);
}

// ============================================================
// 阅读主题 A — 极简 (Swiss Minimal)
// ============================================================

class MinimalReaderColors {
  MinimalReaderColors._();

  // 亮色
  static const background = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF737373);
  static const accent = Color(0xFF2563EB);
  static const highlight = Color(0xFFBFDBFE);
  static const border = Color(0xFFE5E5E5);

  // 暗色
  static const darkBackground = Color(0xFF121212);
  static const darkTextPrimary = Color(0xFFE8E8E8);
  static const darkTextSecondary = Color(0xFF9CA3AF);
  static const darkAccent = Color(0xFF60A5FA);
  static const darkHighlight = Color(0xFF1E3A5F);
}

// ============================================================
// 阅读主题 B — 纸墨 (Paper & Ink)
// ============================================================

class PaperColors {
  PaperColors._();

  // 亮色 — 书页模式
  static const background = Color(0xFFF5F1E8); // 暖白书页
  static const surface = Color(0xFFFFFFFF); // 卡片纯白
  static const textPrimary = Color(0xFF2D2D2D); // 炭灰
  static const textSecondary = Color(0xFF6B6B6B);
  static const accent = Color(0xFF3B6B8B); // 墨蓝
  static const accentLight = Color(0xFF5998B8); // 浅墨蓝
  static const border = Color(0xFFE5DDD0); // 暖灰极淡
  static const highlight = Color(0xFFFFD54F); // 鹅黄荧光笔
  static const aiBubble = Color(0xFFF0EBE3); // AI对话气泡
  static const error = Color(0xFFC4554A); // 暖红
  static const success = Color(0xFF5B8C5A); // 沉稳绿

  // 暗色 — 台灯模式
  static const darkBackground = Color(0xFF1A1A1A);
  static const darkSurface = Color(0xFF242424);
  static const darkTextPrimary = Color(0xFFD4C9B8); // 暖白
  static const darkTextSecondary = Color(0xFF8B8070);
  static const darkAccent = Color(0xFF7BA4C0); // 浅墨蓝
  static const darkBorder = Color(0xFF2E2E2E);
  static const darkHighlight = Color(0xFF5C4A00); // 暗色荧光笔
  static const darkAiBubble = Color(0xFF242420);
}

// ============================================================
// AI 功能区 (两主题共用)
// ============================================================

class AiColors {
  AiColors._();

  static const aiPurple = Color(0xFF7C5CBF); // AI 功能标识
  static const mindmapRoot = Color(0xFF3B6B8B); // 导图根节点
  static const mindmapBranch = Color(0xFF3B8B6B); // 导图分支
  static const mindmapDetail = Color(0xFFC4904A); // 导图细节
  static const mindmapDeep = Color(0xFF7C5CBF); // 导图深层
  static const translateBg = Color(0xFFE8F0F8); // 翻译对照背景
}

// ============================================================
// 阅读主题枚举
// ============================================================

enum ReadingThemeMode {
  minimal, // 极简风格
  paper, // 纸墨风格
}

// ============================================================
// 从 ReadTheme 记录获取预设主题
// ============================================================

class ReadingThemePresets {
  ReadingThemePresets._();

  static const minimalLightBg = '#FFFFFFFF';
  static const minimalLightText = '#FF1A1A1A';
  static const minimalDarkBg = '#FF121212';
  static const minimalDarkText = '#FFE8E8E8';

  static const paperLightBg = '#FFF5F1E8';
  static const paperLightText = '#FF2D2D2D';
  static const paperDarkBg = '#FF1A1A1A';
  static const paperDarkText = '#FFD4C9B8';

  /// 根据阅读主题和亮度获取背景色 hex
  static String backgroundColor(ReadingThemeMode mode, Brightness brightness) {
    return switch (mode) {
      ReadingThemeMode.minimal => brightness == Brightness.light
          ? minimalLightBg
          : minimalDarkBg,
      ReadingThemeMode.paper => brightness == Brightness.light
          ? paperLightBg
          : paperDarkBg,
    };
  }

  /// 根据阅读主题和亮度获取文字色 hex
  static String textColor(ReadingThemeMode mode, Brightness brightness) {
    return switch (mode) {
      ReadingThemeMode.minimal => brightness == Brightness.light
          ? minimalLightText
          : minimalDarkText,
      ReadingThemeMode.paper => brightness == Brightness.light
          ? paperLightText
          : paperDarkText,
    };
  }
}
