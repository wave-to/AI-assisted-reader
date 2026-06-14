import 'package:ai_assisted_reader/config/shared_preference_provider.dart';
import 'package:ai_assisted_reader/l10n/generated/L10n.dart';
import 'package:ai_assisted_reader/providers/reading_theme.dart';
import 'package:ai_assisted_reader/theme/theme_constants.dart';
import 'package:ai_assisted_reader/utils/env_var.dart';
import 'package:ai_assisted_reader/widgets/common/aar_segmented_button.dart';
import 'package:ai_assisted_reader/widgets/settings/settings_title.dart';
import 'package:ai_assisted_reader/widgets/settings/simple_dialog.dart';
import 'package:ai_assisted_reader/widgets/settings/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart' hide Consumer;
import 'package:ai_assisted_reader/widgets/settings/settings_section.dart';
import 'package:ai_assisted_reader/widgets/settings/settings_tile.dart';
import 'package:ai_assisted_reader/enums/bookshelf_folder_style.dart';

const List<Map<String, String>> languageOptions = [
  {'system': 'System'},
  {'English': 'en'},
  {'简体中文': 'zh-CN'},
  {'繁體中文': 'zh-TW'},
  {'文言文': 'zh-LZH'},
  {'Türkçe': 'tr'},
  {'Deutsch': 'de'},
  {'العربية': 'ar'},
  {'Русский': 'ru'},
  {'Français': 'fr'},
  {'Español': 'es'},
  {'Italiano': 'it'},
  {'Português': 'pt'},
  {'日本語': 'ja'},
  {'한국어': 'ko'},
  {'Română': 'ro'},
];

class AppearanceSetting extends StatefulWidget {
  const AppearanceSetting({super.key});

  @override
  State<AppearanceSetting> createState() => _AppearanceSettingState();
}

class _AppearanceSettingState extends State<AppearanceSetting> {
  @override
  Widget build(BuildContext context) {
    final languageSubtitle = Prefs().locale == null
        ? languageOptions[0].values.first
        : languageOptions
            .firstWhere(
                (element) =>
                    element.values.first ==
                    Prefs().locale!.languageCode +
                        (Prefs().locale!.countryCode != null
                            ? "-${Prefs().locale!.countryCode}"
                            : ""),
                orElse: () => languageOptions[0])
            .keys
            .first;

    return settingsSections(
      sections: [
        SettingsSection(
          title: Text(L10n.of(context).settingsAppearanceTheme),
          tiles: [
            const CustomSettingsTile(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: ChangeThemeMode(),
            )),
            SettingsTile.navigation(
                title: Text(L10n.of(context).settingsAppearanceThemeColor),
                leading: const Icon(Icons.color_lens),
                onPressed: (context) async {
                  await showColorPickerDialog(context);
                }),
            SettingsTile.switchTile(
              title: const Text("OLED Dark Mode"),
              leading: const Icon(Icons.brightness_2),
              initialValue: Prefs().trueDarkMode,
              onToggle: (bool value) {
                setState(() {
                  Prefs().trueDarkMode = value;
                });
              },
            ),
            SettingsTile.switchTile(
              title: Text(L10n.of(context).eInkMode),
              leading: const Icon(Icons.contrast),
              initialValue: Prefs().eInkMode,
              onToggle: (bool value) {
                setState(() {
                  Prefs().saveThemeModeToPrefs('light');
                  Prefs().eInkMode = value;
                });
              },
            ),
            // 阅读主题选择
            const CustomSettingsTile(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: _ReadingThemeSelector(),
              ),
            ),
          ],
        ),
        SettingsSection(
            title: Text(L10n.of(context).settingsAppearanceDisplay),
            tiles: [
              SettingsTile.navigation(
                  title: Text(L10n.of(context).settingsAppearanceLanguage),
                  value: Text(languageSubtitle),
                  leading: const Icon(Icons.language),
                  onPressed: (context) {
                    showLanguagePickerDialog(context);
                  }),
              SettingsTile.switchTile(
                title:
                    Text(L10n.of(context).settingsAppearanceOpenBookAnimation),
                leading: const Icon(Icons.animation),
                initialValue: Prefs().openBookAnimation,
                onToggle: (bool value) {
                  setState(() {
                    Prefs().openBookAnimation = value;
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(L10n.of(context).settingsAdvancedAutoHideBottomBar),
                leading: const Icon(Icons.vertical_align_bottom),
                initialValue: Prefs().autoHideBottomBar,
                onToggle: (value) {
                  Prefs().autoHideBottomBar = value;
                  setState(() {});
                },
              ),
              SettingsTile.switchTile(
                title: Text(L10n.of(context).reduceVibrationFeedback),
                leading: const Icon(Icons.vibration),
                initialValue: Prefs().reduceVibrationFeedback,
                onToggle: (bool value) {
                  setState(() {
                    Prefs().reduceVibrationFeedback = value;
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(L10n.of(context).readingPageShowActionLabels),
                leading: const Icon(Icons.subtitles_outlined),
                initialValue: Prefs().showActionLabels,
                onToggle: (bool value) {
                  setState(() {
                    Prefs().showActionLabels = value;
                  });
                },
                description:
                    Text(L10n.of(context).readingPageShowActionLabelsTips),
              ),
            ]),
        SettingsSection(
            title: Text(L10n.of(context).settingsBookshelfCover),
            tiles: [
              CustomSettingsTile(
                  child: ListTile(
                title: Text(L10n.of(context).settingsBookshelfCoverWidth),
                subtitle: Row(
                  children: [
                    Text(Prefs().bookCoverWidth.toStringAsFixed(0)),
                    Expanded(
                      child: Slider(
                        value: Prefs().bookCoverWidth,
                        onChanged: (value) {
                          setState(() {
                            Prefs().bookCoverWidth = value;
                          });
                        },
                        max: 260,
                        min: 80,
                        divisions: 18,
                      ),
                    ),
                  ],
                ),
              )),
              CustomSettingsTile(
                  child: ListTile(
                title: Text(L10n.of(context).settingsBookshelfFolderStyle),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: AarSegmentedButton<BookshelfFolderStyle>(
                    segments: [
                      SegmentButtonItem(
                        label: L10n.of(context)
                            .settingsBookshelfFolderStyleOverlap,
                        value: BookshelfFolderStyle.stacked,
                        icon: Icon(Icons.layers),
                      ),
                      SegmentButtonItem(
                        label:
                            L10n.of(context).settingsBookshelfFolderStyleGrid,
                        value: BookshelfFolderStyle.grid2x2,
                        icon: Icon(Icons.grid_view),
                      ),
                    ],
                    selected: {Prefs().bookshelfFolderStyle},
                    onSelectionChanged: (value) {
                      setState(() {
                        Prefs().bookshelfFolderStyle = value.first;
                      });
                    },
                  ),
                ),
              )),
              SettingsTile.switchTile(
                title: Text(
                    L10n.of(context).settingsBookshelfDefaultCoverShowTitle),
                leading: const Icon(Icons.title),
                initialValue: Prefs().showBookTitleOnDefaultCover,
                onToggle: (bool value) {
                  setState(() {
                    Prefs().showBookTitleOnDefaultCover = value;
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                    L10n.of(context).settingsBookshelfDefaultCoverShowAuthor),
                leading: const Icon(Icons.person),
                initialValue: Prefs().showAuthorOnDefaultCover,
                onToggle: (bool value) {
                  setState(() {
                    Prefs().showAuthorOnDefaultCover = value;
                  });
                },
              ),
              // SettingsTile.switchTile(
              //   title: Text(
              //       L10n.of(context).settingsAdvancedUseOriginalCoverRatio),
              //   leading: const Icon(Icons.photo_size_select_large_outlined),
              //   initialValue: Prefs().useOriginalCoverRatio,
              //   onToggle: (bool value) {
              //     setState(() {
              //       Prefs().useOriginalCoverRatio = value;
              //     });
              //   },
              // ),
            ]),
        SettingsSection(
          title: Text(L10n.of(context).settingsAppearanceBottomNavigatorShow),
          tiles: [
            if (EnvVar.enableAIFeature)
              SettingsTile.switchTile(
                title: Text(L10n.of(context).navBarAI),
                initialValue: Prefs().bottomNavigatorShowAI,
                onToggle: (bool value) {
                  setState(() {
                    Prefs().bottomNavigatorShowAI = value;
                  });
                },
              ),
            SettingsTile.switchTile(
              title: Text(L10n.of(context).navBarStatistics),
              initialValue: Prefs().bottomNavigatorShowStatistics,
              onToggle: (bool value) {
                setState(() {
                  Prefs().bottomNavigatorShowStatistics = value;
                });
              },
            ),
            SettingsTile.switchTile(
              title: Text(L10n.of(context).navBarNotes),
              initialValue: Prefs().bottomNavigatorShowNote,
              onToggle: (bool value) {
                setState(() {
                  Prefs().bottomNavigatorShowNote = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showReadingThemeDialog(BuildContext context, WidgetRef ref) {
    final current = ref.read(readingThemeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('选择阅读主题'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ReadingThemeOption(
              mode: ReadingThemeMode.minimal,
              title: '极简风格',
              subtitle: '纯白底 · 高对比 · 无阴影 · 功能性优先',
              isSelected: current == ReadingThemeMode.minimal,
              onTap: () {
                ref.read(readingThemeProvider.notifier).setMode(ReadingThemeMode.minimal);
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 12),
            _ReadingThemeOption(
              mode: ReadingThemeMode.paper,
              title: '纸墨风格',
              subtitle: '暖白书页 · 炭灰文字 · 微阴影 · 长时间阅读舒适',
              isSelected: current == ReadingThemeMode.paper,
              onTap: () {
                ref.read(readingThemeProvider.notifier).setMode(ReadingThemeMode.paper);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(L10n.of(context).commonCancel),
          ),
        ],
      ),
    );
  }
}

class _ReadingThemeOption extends StatelessWidget {
  const _ReadingThemeOption({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final ReadingThemeMode mode;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = mode == ReadingThemeMode.minimal
        ? MinimalReaderColors.background
        : PaperColors.background;
    final textColor = mode == ReadingThemeMode.minimal
        ? MinimalReaderColors.textPrimary
        : PaperColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: theme.colorScheme.primary),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 12,
            )),
          ],
        ),
      ),
    );
  }
}

class _ReadingThemeSelector extends ConsumerWidget {
  const _ReadingThemeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingTheme = ref.watch(readingThemeProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.book, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              '阅读主题',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ReadingThemeCard(
                mode: ReadingThemeMode.minimal,
                title: '极简',
                accent: '纯白 · 高对比 · 无阴影',
                isSelected: readingTheme == ReadingThemeMode.minimal,
                onTap: () => ref
                    .read(readingThemeProvider.notifier)
                    .setMode(ReadingThemeMode.minimal),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ReadingThemeCard(
                mode: ReadingThemeMode.paper,
                title: '纸墨',
                accent: '暖白书页 · 炭灰 · 护眼',
                isSelected: readingTheme == ReadingThemeMode.paper,
                onTap: () => ref
                    .read(readingThemeProvider.notifier)
                    .setMode(ReadingThemeMode.paper),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReadingThemeCard extends StatelessWidget {
  const _ReadingThemeCard({
    required this.mode,
    required this.title,
    required this.accent,
    required this.isSelected,
    required this.onTap,
  });

  final ReadingThemeMode mode;
  final String title;
  final String accent;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = mode == ReadingThemeMode.minimal
        ? MinimalReaderColors.background
        : PaperColors.background;
    final textColor = mode == ReadingThemeMode.minimal
        ? MinimalReaderColors.textPrimary
        : PaperColors.textPrimary;
    final accentColor = mode == ReadingThemeMode.minimal
        ? MinimalReaderColors.accent
        : PaperColors.accent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? accentColor : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.check_circle, size: 14, color: accentColor),
                  ),
                Text(title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )),
              ],
            ),
            const SizedBox(height: 2),
            Text(accent,
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontSize: 10,
                )),
          ],
        ),
      ),
    );
  }
}

void showLanguagePickerDialog(BuildContext context) {
  final title = L10n.of(context).settingsAppearanceLanguage;
  final saveToPrefs = Prefs().saveLocaleToPrefs;

  final children = languageOptions.map((e) {
    final key = e.keys.first;
    final value = e[key]!;
    return dialogOption(key, value, saveToPrefs);
  }).toList();
  showSimpleDialog(title, saveToPrefs, children);
}

Future<void> showColorPickerDialog(BuildContext context) async {
  final prefsProvider = Provider.of<Prefs>(context, listen: false);
  final currentColor = prefsProvider.themeColor;

  Color pickedColor = currentColor;

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(L10n.of(context).settingsAppearanceThemeColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickedColor,
            onColorChanged: (color) {
              pickedColor = color;
            },
            enableAlpha: false,
            displayThumbColor: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(L10n.of(context).commonCancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(L10n.of(context).commonOk),
            onPressed: () {
              prefsProvider.saveThemeToPrefs(pickedColor.value);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
