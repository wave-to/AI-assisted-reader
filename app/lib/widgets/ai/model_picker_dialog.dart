import 'package:ai_assisted_reader/l10n/generated/L10n.dart';
import 'package:ai_assisted_reader/models/ai_provider.dart';
import 'package:ai_assisted_reader/service/ai/ai_model_service.dart';
import 'package:ai_assisted_reader/widgets/common/aar_button.dart';
import 'package:flutter/material.dart';

/// A dialog that lets the user select a model from a dropdown
/// (fetched from API or built-in list), with manual input always available.
///
/// Returns the selected/entered model string, or `null` if cancelled.
Future<String?> showModelPickerDialog({
  required BuildContext context,
  required AiProvider provider,
  String? currentModel,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _ModelPickerDialog(
      provider: provider,
      currentModel: currentModel,
    ),
  );
}

class _ModelPickerDialog extends StatefulWidget {
  const _ModelPickerDialog({
    required this.provider,
    this.currentModel,
  });

  final AiProvider provider;
  final String? currentModel;

  @override
  State<_ModelPickerDialog> createState() => _ModelPickerDialogState();
}

class _ModelPickerDialogState extends State<_ModelPickerDialog> {
  late TextEditingController _controller;
  List<String> _models = [];
  bool _isFetching = false;
  String? _fetchError;
  bool _useManualInput = false;

  /// Whether we can try fetching from the API
  bool get _canFetch =>
      widget.provider.hasValidKey && widget.provider.url.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentModel ?? '',
    );
    // Always load built-in models immediately
    _models = getBuiltInModels(url: widget.provider.url);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchModels() async {
    setState(() {
      _isFetching = true;
      _fetchError = null;
    });

    try {
      final apiKey = widget.provider.currentApiKey ?? '';
      final models = await fetchAiModels(
        url: widget.provider.url,
        apiKey: apiKey,
      );
      if (mounted) {
        setState(() {
          _models = models;
          _isFetching = false;
          if (models.isEmpty) {
            _fetchError = L10n.of(context).settingsAiProviderNoModelsFound;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFetching = false;
          _fetchError = L10n.of(context)
              .settingsAiProviderFetchModelsFailed(e.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.aiModelSwitchTitle),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle between dropdown and manual input
            Row(
              children: [
                Expanded(
                  child: Text(
                    _useManualInput
                        ? l10n.aiModelEnterManually
                        : l10n.aiModelOrSelectBelow,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurface),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _useManualInput = !_useManualInput),
                  icon: Icon(
                    _useManualInput ? Icons.list : Icons.edit,
                    size: 18,
                  ),
                  label: Text(
                    _useManualInput
                        ? l10n.aiModelOrSelectBelow
                        : l10n.aiModelEnterManually,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (_useManualInput)
              // Manual input mode
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: l10n.aiModelEnterManually,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                autofocus: true,
              )
            else ...[
              // Dropdown + refresh button
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _models.contains(_controller.text)
                          ? _controller.text
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      hint: Text(l10n.aiModelEnterManually),
                      items: _models.map((model) {
                        return DropdownMenuItem(
                          value: model,
                          child: Text(
                            model,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _controller.text = value);
                        }
                      },
                    ),
                  ),
                  if (_canFetch) ...[
                    const SizedBox(width: 8),
                    AarButton(
                      onPressed: _isFetching ? null : _fetchModels,
                      isLoading: _isFetching,
                      child: Icon(
                        Icons.refresh,
                        size: 20,
                        color: _isFetching
                            ? null
                            : theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // Error message
            if (_fetchError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _fetchError!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ),

            // Current model preview
            if (_controller.text.isNotEmpty && !_useManualInput)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        size: 14, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '当前: ${_controller.text}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () {
            final text = _controller.text.trim();
            Navigator.pop(context, text.isEmpty ? null : text);
          },
          child: Text(l10n.commonConfirm),
        ),
      ],
    );
  }
}
