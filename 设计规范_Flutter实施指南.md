# BookReader 设计规范 — Flutter 实施指南

> 基于 UI/UX Pro Max 设计引擎 | 2026-06-14
> 风格: Swiss Modernism 2.0 + Paper & Ink + AI-Native UI

---

## 0. 设计系统总览

### 0.1 设计 DNA

| 层级 | 风格 | 用途 |
|------|------|------|
| System UI | Swiss Modernism 2.0 | App shell, 导航, 设置, 对话框 |
| Reading UI | Paper & Ink (E-Ink/Paper) | 阅读器画布, 书页底色 |
| AI UI | AI-Native UI | 聊天面板, 思维导图, 提示词 |

### 0.2 核心原则

- **数学间距**: 基于 8px 网格系统 (4, 8, 12, 16, 20, 24, 32, 48, 64)
- **零阴影/微阴影**: 系统 UI 无阴影; 阅读卡片仅 0 2px 8px rgba(0,0,0,0.04)
- **圆角系统**: 0, 4, 8, 12, 16, 20, 24 (瑞士风格低圆角; 卡片中等圆角)
- **无动画/瞬间过渡**: 页面切换 0ms; hover 反馈 150-200ms
- **高对比度**: 正文 7:1+, 辅助文字 4.5:1+
- **44x44px 最小触摸目标**: 所有可交互元素

### 0.3 色彩令牌映射

```
系统 UI (SwissColors):
  bg:          #FAFAFA → Theme.scaffoldBackgroundColor
  surface:     #FFFFFF → Theme.cardColor / surfaceContainer
  textPrimary: #1A1A1A → Theme.textTheme.bodyLarge
  textSecondary: #737373 → Theme.textTheme.bodyMedium
  accent:      #2563EB → Theme.colorScheme.primary
  border:      #E5E5E5 → Theme.dividerColor / outline

阅读 (PaperColors):
  页面底:      #F5F1E8 → 阅读器背景
  文字:        #2D2D2D → 阅读器正文
  强调:        #3B6B8B → 阅读器链接/选中
  高亮:        #FFD54F → 选中文本高亮

AI (AiColors):
  标识紫:      #7C5CBF → AI 按钮/图标/气泡边框
  导图根:      #3B6B8B
  导图分支:    #3B8B6B
```

---

## 1. 书架首页 (BookshelfPage)

### 1.1 设计目标
- 干净、有序的书籍展示
- 暖白卡片风格 (Paper Colors 的 surface)
- 清晰的信息层级
- 快速扫描和查找

### 1.2 布局结构

```
┌─────────────────────────────────┐
│  AppBar (Swiss, forceTransparent) │
│  ┌─────────────────────────────┐ │
│  │ 🔍 搜索书籍或笔记...        │ │  ← FilledContainer, surface+80alpha
│  └─────────────────────────────┘ │
│  [ 已读完 | 阅读中 | 未开始 ]  🔖 │  ← FilterChip 行
│                                 │
│  ┌──────┐ ┌──────┐ ┌──────┐   │
│  │      │ │      │ │      │   │
│  │ 封面 │ │ 封面 │ │ 封面 │   │  ← 3列 GridView
│  │      │ │      │ │      │   │
│  │ 书名 │ │ 书名 │ │ 书名 │   │
│  └──────┘ └──────┘ └──────┘   │
│  ┌──────┐ ┌──────┐ ┌──────┐   │
│  │ ...  │ │ ...  │ │ ...  │   │
│  └──────┘ └──────┘ └──────┘   │
│                                 │
│         [BottomNav Bar]         │  ← 毛玻璃效果
└─────────────────────────────────┘
```

### 1.3 Widget 实施规范

#### A. 封面卡片 (BookCover)

**当前问题**: 无封面书籍使用随机饱和色, 与 Swiss 风格不协调。

**修改方案**:
```dart
// book_cover.dart 修改点:
// 1. 默认封面背景色改为 Swiss 色板
final backgroundColor = SwissColors.surface; // 替代 Colors.primaries
final textColor = SwissColors.textPrimary;

// 2. 边框改为 Swiss border
side: BorderSide(width: 0.5, color: SwissColors.border)

// 3. 角落图标颜色降低透明度
color: SwissColors.textSecondary.withValues(alpha: 0.08)
```

**设计令牌**:
- 圆角: 8px (封面), 12px (文件夹预览)
- 边框: 0.5px SwissColors.border
- 阴影: 无 (只有文件夹预览使用 elevation 1)
- 默认封面背景: `SwissColors.surface` (纯白)
- 默认封面文字: `SwissColors.textPrimary` (#1A1A1A)

#### B. 书籍项目 (BookItem / BookFolder)

**修改方案**:
```dart
// book_folder.dart 修改点:
// 1. 文件夹名文字样式
style: Theme.of(context).textTheme.labelMedium?.copyWith(
  color: SwissColors.textPrimary,
  fontWeight: FontWeight.w500,
)

// 2. 文件夹预览边框
border: Border.all(
  color: SwissColors.border,
  width: 0.5,
)

// 3. 拖拽目标高亮
// 替代 scale transition, 使用背景色变化
color: willAcceptBook 
  ? SwissColors.accent.withAlpha(15) 
  : Colors.transparent
```

#### C. 筛选栏 (FilterBar)

**修改方案**:
```dart
// bookshelf_page.dart buildFilterBar():
// 1. 容器高度 44px (满足最小触摸目标)
Container(height: 44, ...)

// 2. FilterChip 样式
FilterChip(
  backgroundColor: SwissColors.surface,
  selectedColor: SwissColors.accent.withAlpha(20),
  checkmarkColor: SwissColors.accent,
  side: BorderSide(color: SwissColors.border),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
)

// 3. 标签按钮图标
Icon(EvaIcons.pricetags_outline, size: 20, color: SwissColors.textSecondary)
```

#### D. 搜索栏

**修改方案**:
```dart
// 搜索栏容器
FilledContainer(
  color: SwissColors.surface,
  radius: 12, // 增加圆角
  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  child: Row(children: [
    Icon(Icons.search, color: SwissColors.textSecondary, size: 20),
    SizedBox(width: 10),
    Expanded(child: Text(..., style: ...)),
  ]),
)
```

#### E. 背景

**修改方案**:
```dart
// 移除 RadialGradient (非 Swiss 风格)
// 改为纯色背景
Container(
  color: Theme.of(context).scaffoldBackgroundColor, // SwissColors.background
  child: Scaffold(...)
)
```

### 1.4 触控与交互

- FilterChip: 44px 高, 8px 间距
- 封面长按: 300ms 触发拖拽
- 排序按钮: 44x44px 触摸区域
- 导入按钮: 44x44px

---

## 2. 阅读器页面 (ReadingPage)

### 2.1 设计目标
- 沉浸式无干扰阅读
- 支持 2 种阅读主题切换 (极简/纸墨)
- 半透明工具栏仅在需要时出现
- AI 面板优雅集成

### 2.2 布局结构

```
┌─────────────────────────────────┐
│                                 │
│  [半透明 AppBar - 点击出现]      │
│  ← 书名           AI ✨ ⋮     │
│                                 │
│                                 │
│        📖 书籍内容              │
│     (按阅读主题渲染背景)         │
│                                 │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 📑  📝  📊  🎨  🎧    │   │  ← 半透明底部工具栏
│  └─────────────────────────┘   │
│                                 │
│  [可选 AI 分割面板 →]           │
└─────────────────────────────────┘
```

### 2.3 Widget 实施规范

#### A. AppBar 覆盖层

**当前问题**: 纯色背景遮挡内容。

**修改方案**:
```dart
// reading_page.dart AppBar 部分
AppBar(
  forceMaterialTransparency: true,
  backgroundColor: Colors.transparent,
  surfaceTintColor: Colors.transparent,
  // 当显示工具栏时, 添加轻微模糊背景
  flexibleSpace: bottomBarOffstage ? null : BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    child: Container(color: SwissColors.surface.withAlpha(180)),
  ),
  title: Text(_book.title, 
    style: TextStyle(color: SwissColors.textPrimary),
    overflow: TextOverflow.ellipsis,
  ),
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: SwissColors.textPrimary),
  ),
  actions: [
    // AI 按钮使用 AiColors.aiPurple
    IconButton(
      icon: Icon(Icons.auto_awesome, color: AiColors.aiPurple),
    ),
    // 其他按钮使用 textSecondary
    IconButton(
      icon: Icon(Icons.bookmark_border, color: SwissColors.textSecondary),
    ),
    IconButton(
      icon: Icon(EvaIcons.more_vertical, color: SwissColors.textSecondary),
    ),
  ],
)
```

#### B. 底部工具栏

**修改方案**:
```dart
// 底部 BottomSheet 背景
Container(
  decoration: BoxDecoration(
    color: SwissColors.surface.withAlpha(230),
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ToolbarButton(icon: Icons.toc, label: '目录'),
        _ToolbarButton(icon: EvaIcons.edit, label: '笔记'),
        _ToolbarButton(icon: Icons.data_usage, label: '进度'),
        _ToolbarButton(icon: Icons.color_lens, label: '样式'),
        _ToolbarButton(icon: EvaIcons.headphones, label: '朗读'),
      ],
    ),
  ),
)

// 工具栏按钮组件 (44x44 触摸区域)
Widget _ToolbarButton({IconData icon, String label}) {
  return InkWell(
    onTap: ...,
    child: SizedBox(
      width: 44, height: 44,
      child: Icon(icon, color: SwissColors.textSecondary, size: 22),
    ),
  );
}
```

#### C. 背景遮罩 (点击隐藏工具栏)

**修改方案**:
```dart
// GestureDetector 覆盖层
Container(
  color: SwissColors.textPrimary.withAlpha(20), // 更轻柔
)
```

#### D. 阅读主题集成

**epub_player 渲染时**应用阅读主题颜色:
```dart
// 通过 initialThemes 传递阅读主题
// 极简: bg=#FFFFFF, text=#1A1A1A
// 纸墨: bg=#F5F1E8, text=#2D2D2D
```

#### E. AI 分割面板分隔线

```dart
// 拖拽调整大小的分隔线
VerticalDivider(
  width: 1,
  thickness: 1,
  color: SwissColors.border,
)
```

### 2.4 阅读主题切换集成

当前 `appearance.dart` 已有阅读主题选择器。需要确保 `epub_player` 读取主题并应用:
- 监听 `readingThemeProvider`
- 更新 epub 渲染的背景色和文字色

---

## 3. AI 对话面板 (AiChatStream)

### 3.1 设计目标
- AI-Native UI 风格 (参考 styles.csv row 43)
- 对话气泡清晰分层
- 紫色系 AI 标识
- 流畅的打字机/流式效果
- 最小化 UI chrome

### 3.2 布局结构

```
┌─────────────────────────────────┐
│  AppBar: AI 对话    📄 ✏️ ⋮  │  ← Swiss 风格
│                                 │
│  ┌─────────────────────────┐   │
│  │  🤖 这是AI助手的回复...  │   │  ← AI 气泡 (surface)
│  │     带思维链展开         │   │
│  └─────────────────────────┘   │
│          ┌──────────────────┐  │
│          │  用户的提问...    │  │  ← 用户气泡 (surfaceContainer)
│          └──────────────────┘  │
│  ┌─────────────────────────┐   │
│  │  🤖 思维导图/工具调用    │   │
│  └─────────────────────────┘   │
│                                 │
│  [快速提示词 chips 行]          │  ← ActionChip 水平滚动
│  ┌─────────────────────────┐   │
│  │ 输入消息...          📤  │   │  ← 输入框 (FilledContainer, r=15)
│  └─────────────────────────┘   │
│  Claude · fable-5  ⚙️         │  ← 模型选择器行
└─────────────────────────────────┘
```

### 3.3 Widget 实施规范

#### A. 消息气泡

**修改方案**:
```dart
// ai_chat_stream.dart _buildMessageItem()
// AI 消息 (左侧)
Container(
  padding: EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: SwissColors.surface,
    borderRadius: BorderRadius.only(
      topLeft: Radius.zero,
      topRight: Radius.circular(14),
      bottomLeft: Radius.circular(14),
      bottomRight: Radius.circular(14),
    ),
    border: Border.all(
      color: AiColors.aiPurple.withAlpha(30), // 淡紫边框标识AI
      width: 0.5,
    ),
  ),
)

// 用户消息 (右侧)
Container(
  padding: EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(14),
      topRight: Radius.zero,
      bottomLeft: Radius.circular(14),
      bottomRight: Radius.circular(14),
    ),
  ),
)
```

#### B. 思维链 (Thinking Panel)

**修改方案**:
```dart
// _buildThinkingPanel()
// 左侧 accent 线颜色改为 AiColors.aiPurple
Container(
  decoration: BoxDecoration(
    border: Border(
      left: BorderSide(
        color: AiColors.aiPurple.withAlpha(100),
        width: 2,
      ),
    ),
  ),
)

// 思维链图标
Icon(
  Icons.psychology_alt_outlined,
  size: 16,
  color: AiColors.aiPurple,
)
```

#### C. 快速提示词 Chips

**修改方案**:
```dart
// 系统提示词 (横滚行)
ActionChip(
  avatar: Icon(icon, size: 16, color: SwissColors.accent),
  label: Text(label, style: TextStyle(fontSize: 12)),
  backgroundColor: SwissColors.surface,
  side: BorderSide(color: SwissColors.border),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
)

// 阅读器内 quick prompt chips  
// 使用 AiColors.aiPurple 色调
ActionChip(
  avatar: Icon(chip.icon, size: 18, color: AiColors.aiPurple),
  label: Text(chip.label),
  backgroundColor: AiColors.aiPurple.withAlpha(10),
  side: BorderSide(color: AiColors.aiPurple.withAlpha(40)),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
)
```

#### D. 输入框

**当前**: FilledContainer, radius=15

**优化方案**:
```dart
FilledContainer(
  padding: EdgeInsets.all(6),
  radius: 16,
  color: SwissColors.surface,
  // 添加细边框
  decoration: BoxDecoration(
    border: Border.all(color: SwissColors.border, width: 0.5),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(children: [
    // Quick prompt chips row
    // TextField
    // Bottom row (provider selector + send button)
  ]),
)
```

#### E. 模型选择器

**修改方案**:
```dart
// 紧凑的下拉按钮
PopupMenuButton(
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: SwissColors.accent.withAlpha(10),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: SwissColors.accent.withAlpha(40)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      _providerLogo(currentProvider) ?? SizedBox.shrink(),
      SizedBox(width: 6),
      Text(label, style: TextStyle(fontSize: 11, color: SwissColors.accent)),
      SizedBox(width: 4),
      Icon(Icons.expand_more, size: 14, color: SwissColors.accent),
    ]),
  ),
)
```

#### F. 空状态

**修改方案**:
```dart
// buildEmptyState()
Center(
  child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.auto_awesome, size: 48, color: AiColors.aiPurple.withAlpha(80)),
    SizedBox(height: 16),
    Text('试试快速提问', style: theme.textTheme.titleMedium?.copyWith(
      color: SwissColors.textSecondary,
    )),
    SizedBox(height: 16),
    Wrap(
      spacing: 10, runSpacing: 10,
      children: _suggestedPrompts.map((prompt) => ActionChip(
        label: Text(prompt),
        backgroundColor: SwissColors.surface,
        side: BorderSide(color: SwissColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      )).toList(),
    ),
  ]),
)
```

### 3.4 Bottom Sheet 模式 (移动端)

```dart
showModalBottomSheet(
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    height: MediaQuery.of(context).size.height * 0.45, // 45%
    decoration: BoxDecoration(
      color: SwissColors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: AiChatStream(...),
  ),
)
```

---

## 4. 底部导航栏 (HomePage)

### 4.1 设计目标
- Swiss Minimal 风格
- 毛玻璃效果 (小屏手机)
- NavigationRail (平板/桌面)

### 4.2 底部导航条

**当前**: 已有毛玻璃效果 (BackdropFilter + blur)

**优化方案**:
```dart
// home_page.dart BottomBar
Container(
  height: 64,
  decoration: BoxDecoration(
    color: SwissColors.surface.withAlpha(200),
    borderRadius: BorderRadius.circular(32),
    border: Border.all(color: SwissColors.border, width: 0.5),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(32),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: BottomNavigationBar(
        selectedItemColor: SwissColors.accent,
        unselectedItemColor: SwissColors.textSecondary,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
  ),
)
```

### 4.3 NavigationRail (宽屏)

**修改方案**:
```dart
// 左侧导航栏
FilledContainer(
  margin: EdgeInsets.all(12),
  color: SwissColors.surface,
  radius: 16,
  child: NavigationRail(
    selectedIconTheme: IconThemeData(color: SwissColors.accent),
    unselectedIconTheme: IconThemeData(color: SwissColors.textSecondary),
    selectedLabelTextStyle: TextStyle(color: SwissColors.accent, fontSize: 11),
    unselectedLabelTextStyle: TextStyle(color: SwissColors.textSecondary, fontSize: 11),
    indicatorColor: SwissColors.accent.withAlpha(20),
    backgroundColor: Colors.transparent,
  ),
)
```

---

## 5. 全局设计令牌速查表

### 5.1 颜色

| 令牌 | 亮色值 | 暗色值 | 用途 |
|------|--------|--------|------|
| `--bg` | #FAFAFA | #121212 | 页面/脚手架背景 |
| `--surface` | #FFFFFF | #1E1E1E | 卡片/容器 |
| `--text-primary` | #1A1A1A | #E8E8E8 | 标题、正文 |
| `--text-secondary` | #737373 | #9CA3AF | 辅助文字、图标 |
| `--accent` | #2563EB | #60A5FA | 强调色、选中态 |
| `--border` | #E5E5E5 | #2E2E2E | 分割线、卡片边框 |
| `--ai-purple` | #7C5CBF | #9B8ECC | AI 功能标识 |
| `--paper-bg` | #F5F1E8 | #1A1A1A | 阅读器纸墨模式 |
| `--paper-text` | #2D2D2D | #D4C9B8 | 阅读器纸墨文字 |

### 5.2 间距 (8px grid)

| 尺寸 | 值 | 用途 |
|------|-----|------|
| xs | 4 | 图标-文字间距 |
| sm | 8 | chip 间距, 内边距 |
| md | 12 | 卡片内边距 |
| lg | 16 | 页面水平边距 |
| xl | 20 | 网格间距 |
| 2xl | 24 | 区块间距 |
| 3xl | 32 | 区域间距 |

### 5.3 圆角

| 尺寸 | 值 | 用途 |
|------|-----|------|
| none | 0 | 分割线、工具栏 |
| sm | 4 | FilterChip, tag |
| md | 8 | 书封面、按钮 |
| lg | 12 | 搜索栏、输入框 |
| xl | 16 | 卡片、对话气泡 |
| 2xl | 20 | 模态框、底部导航 |
| 3xl | 24 | 大卡片 |

### 5.4 阴影

| 级别 | 值 | 用途 |
|------|-----|------|
| none | 无 | 大部分元素 (Swiss风格) |
| subtle | `0 2px 8px rgba(0,0,0,0.04)` | 悬浮卡片 |
| medium | `0 4px 12px rgba(0,0,0,0.08)` | 模态框 |

### 5.5 动画

| 类型 | 时长 | 缓动 |
|------|------|------|
| 页面切换 | 0ms (瞬间) | - |
| 工具栏显隐 | 200ms | ease-out |
| 消息气泡出现 | 150ms | ease-out |
| 思维链展开 | 200ms | ease-in-out |
| 拖拽高亮 | 200ms | ease |

---

## 6. 实施优先级

### P0 — 立即实施
1. **BookshelfPage 背景**: 移除 RadialGradient (非 Swiss)
2. **BookCover 默认颜色**: 从 Colors.primaries 改为 Swiss 色板
3. **AI 气泡**: 添加 AiColors.aiPurple 标识边框
4. **底部导航样式**: 选中色改为 SwissColors.accent

### P1 — 核心体验
5. **阅读器工具栏**: 半透明模糊背景
6. **AI 快速提示词**: 统一样式
7. **筛选栏**: 增大到 44px 高度
8. **搜索栏**: 增加圆角和内边距

### P2 — 完善
9. **文件夹预览**: 统一边框颜色
10. **思维链面板**: AI 紫色标识
11. **空状态页面**: 统一风格

---

## 7. 文件变更清单

```
修改:
  app/lib/widgets/bookshelf/book_cover.dart       ← 默认封面颜色
  app/lib/widgets/bookshelf/book_folder.dart       ← 边框、文字样式
  app/lib/page/home_page/bookshelf_page.dart       ← 背景、筛选栏
  app/lib/page/home_page.dart                      ← 底部导航样式
  app/lib/page/reading_page.dart                   ← 工具栏半透明
  app/lib/widgets/ai/ai_chat_stream.dart           ← 气泡、chips、输入框
  app/lib/utils/color_scheme.dart                  ← 卡片主题微调

新建:
  (无 — 所有修改在现有文件上进行)
```
