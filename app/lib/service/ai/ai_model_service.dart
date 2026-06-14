import 'dart:convert';
import 'package:http/http.dart' as http;

// ============================================================
// 各 AI 提供商内置模型清单（定期维护）
// ============================================================

/// Claude 模型（Anthropic 无 /models API，手动维护）
const _claudeModels = [
  'claude-fable-5', // 2026 最新旗舰（平衡版）
  'claude-opus-4-8', // 最强推理
  'claude-sonnet-4-6', // 性价比
  'claude-haiku-4-5-20251001', // 极速版
  'claude-3-5-sonnet-20240620', // 旧版
  'claude-3-opus-20240229', // 旧版旗舰
];

/// OpenAI / 兼容接口的常见模型
const _openaiCompatibleModels = [
  'gpt-4o',
  'gpt-4o-mini',
  'gpt-4.1',
  'gpt-4.1-mini',
  'gpt-4-turbo',
  'gpt-3.5-turbo',
  'o1',
  'o1-mini',
  'o3-mini',
];

/// DeepSeek 模型
const _deepseekModels = [
  'deepseek-chat', // DeepSeek-V3
  'deepseek-reasoner', // DeepSeek-R1
];

/// OpenRouter 常用模型
const _openrouterModels = [
  'openai/gpt-4o',
  'openai/gpt-4o-mini',
  'anthropic/claude-fable-5',
  'anthropic/claude-opus-4-8',
  'anthropic/claude-sonnet-4-6',
  'google/gemini-2.5-pro',
  'google/gemini-2.5-flash',
  'deepseek/deepseek-chat',
  'deepseek/deepseek-reasoner',
  'meta-llama/llama-4-maverick',
  'qwen/qwen-3',
];

// ============================================================
// 智能模型获取：先试图从 API 获取，失败则降级到内置清单
// ============================================================

/// 从 URL 推断提供商类型
String _inferProviderType(String url) {
  final lower = url.toLowerCase();
  if (lower.contains('anthropic.com')) return 'claude';
  if (lower.contains('deepseek.com')) return 'deepseek';
  if (lower.contains('openrouter.ai')) return 'openrouter';
  if (lower.contains('dashscope.aliyuncs.com')) return 'dashscope';
  if (lower.contains('generativelanguage.googleapis.com')) return 'gemini';
  return 'openai'; // 默认走 OpenAI 兼容路径
}

/// 获取内置模型清单（无需网络）
List<String> getBuiltInModels({required String url}) {
  final providerType = _inferProviderType(url);
  switch (providerType) {
    case 'claude':
      return _claudeModels;
    case 'deepseek':
      return _deepseekModels;
    case 'openrouter':
      return _openrouterModels;
    case 'gemini':
      return _openaiCompatibleModels; // Gemini 也走兼容接口时用
    case 'dashscope':
      return ['qwen-long', 'qwen-plus', 'qwen-max', 'qwen-turbo'];
    default:
      return _openaiCompatibleModels;
  }
}

/// 尝试从 OpenAI 兼容 /v1/models 接口获取模型列表
///
/// 对于没有此接口的提供商（Claude、Gemini 原生等），直接返回内置清单。
/// 对于有此接口的提供商（OpenAI、DeepSeek、OpenRouter 等），先在线获取，
/// 失败则降级到内置清单。
Future<List<String>> fetchAiModels({
  required String url,
  required String apiKey,
  Duration timeout = const Duration(seconds: 8),
}) async {
  final providerType = _inferProviderType(url);

  // Claude / Gemini 原生没有 /models 接口，直接用内置清单
  if (providerType == 'claude' || providerType == 'gemini') {
    return getBuiltInModels(url: url);
  }

  // 尝试在线获取
  try {
    final baseUrl = _extractBaseUrl(url.trim());

    final modelsUrl =
        baseUrl.endsWith('/') ? '${baseUrl}models' : '$baseUrl/models';

    final response = await http.get(
      Uri.parse(modelsUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    ).timeout(timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> models = data['data'] ?? [];

      if (models.isNotEmpty) {
        final ids = models
            .map<String>((m) => (m['id'] ?? m.toString()) as String)
            .where((id) => _isChatModel(id))
            .toList();
        ids.sort();
        if (ids.isNotEmpty) return ids;
      }
    }
    // 在线获取失败 → 降级到内置清单
    return getBuiltInModels(url: url);
  } catch (_) {
    // 网络错误 → 降级到内置清单
    return getBuiltInModels(url: url);
  }
}

/// 从完整 API URL 中提取 base URL
/// 例如: https://api.openai.com/v1/chat/completions → https://api.openai.com/v1
String _extractBaseUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return url;

  final path = uri.path;

  // 移除常见后缀
  final suffixesToStrip = [
    '/chat/completions',
    '/completions',
    '/messages',
    '/v1/chat/completions',
    '/v1/completions',
    '/v1/messages',
    '/compatible-mode/v1/chat/completions',
  ];

  String cleanPath = path;
  for (final suffix in suffixesToStrip) {
    if (cleanPath.endsWith(suffix)) {
      cleanPath = cleanPath.substring(0, cleanPath.length - suffix.length);
      break;
    }
  }

  // 确保路径以 /v1 结尾
  if (!cleanPath.endsWith('/v1') && !cleanPath.endsWith('/v1/')) {
    if (cleanPath.endsWith('/')) {
      cleanPath = '${cleanPath}v1';
    } else {
      cleanPath = '$cleanPath/v1';
    }
  }

  return uri.replace(path: cleanPath).toString();
}

/// 过滤非 chat 模型（排除 embedding、moderation、audio、dall-e 等）
bool _isChatModel(String id) {
  final lower = id.toLowerCase();
  final excludePatterns = [
    'embedding',
    'moderation',
    'whisper',
    'tts',
    'dall-e',
    'dalle',
    'embed',
    'text-search',
    'babbage',
    'davinci',
    'curie',
    'ada',
    'instruct',
  ];
  return !excludePatterns.any((p) => lower.contains(p));
}
