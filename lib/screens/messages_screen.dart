import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/neighbor_message.dart';
import '../services/app_image_picker.dart';
import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';
import '../utils/flutter_runtime.dart';
import '../widgets/route_pop_scope.dart';
import '../widgets/voice_note_player.dart';

class ChatScreen extends StatefulWidget {
  final List<NeighborMessage> messages;
  final String peerName;
  final String listingTitle;
  final ValueChanged<String> onSend;
  final ValueChanged<VoiceNoteResult>? onSendVoice;
  final void Function(String imagePath, String caption)? onSendImage;
  final VoidCallback onClearHistory;

  const ChatScreen({
    super.key,
    required this.messages,
    this.peerName = '',
    this.listingTitle = '',
    required this.onSend,
    this.onSendVoice,
    this.onSendImage,
    required this.onClearHistory,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _draft = TextEditingController();
  String? _pendingImagePath;

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  Future<void> _confirmClear(BuildContext context) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('clearHistoryTitle')),
        content: Text(dialogContext.tr('clearHistoryBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.tr('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.tr('clear')),
          ),
        ],
      ),
    );
    if (shouldClear == true) widget.onClearHistory();
  }

  void _sendDraft() {
    final image = _pendingImagePath;
    final text = _draft.text.trim();
    if (image != null && widget.onSendImage != null) {
      widget.onSendImage!(image, text);
      _draft.clear();
      setState(() => _pendingImagePath = null);
      return;
    }
    if (text.isEmpty) return;
    widget.onSend(text);
    _draft.clear();
  }

  Future<void> _pickImage({required bool camera}) async {
    if (isFlutterWidgetTest || widget.onSendImage == null) return;
    final picker = const AppImagePicker();
    final path = camera
        ? await picker.pickFromCamera()
        : await picker.pickFromGallery();
    if (!mounted || path == null) return;
    setState(() => _pendingImagePath = path);
  }

  @override
  Widget build(BuildContext context) {
    return RoutePopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const BackButtonIcon(),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: widget.listingTitle.isEmpty
              ? Text(
                  widget.peerName.isEmpty
                      ? context.tr('messagesTitle')
                      : widget.peerName,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.peerName.isEmpty
                          ? context.tr('messagesTitle')
                          : widget.peerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.listingTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
          actions: [
            IconButton(
              tooltip: context.tr('clearConversation'),
              onPressed: () => _confirmClear(context),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: widget.messages.isEmpty
                  ? Center(child: Text(context.tr('messagesEmpty')))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      scrollCacheExtent: WidzewUi.listCacheExtent,
                      shrinkWrap: false,
                      physics: const ClampingScrollPhysics(),
                      itemCount: widget.messages.length,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                      itemBuilder: (context, index) {
                        final message = widget.messages[index];
                        return _ChatBubble(message: message);
                      },
                    ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_pendingImagePath != null && !kIsWeb)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_pendingImagePath!),
                              width: 72,
                              height: 72,
                              cacheWidth: WidzewUi.imageCachePixels(
                                context,
                                72,
                              ),
                              cacheHeight: WidzewUi.imageCachePixels(
                                context,
                                72,
                              ),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const SizedBox(
                                width: 72,
                                height: 72,
                                child: Icon(Icons.broken_image_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(context.tr('photoPreview'))),
                          IconButton(
                            tooltip: context.tr('removePhoto'),
                            onPressed: () =>
                                setState(() => _pendingImagePath = null),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                    child: Row(
                      children: [
                        if (widget.onSendImage != null) ...[
                          IconButton(
                            tooltip: context.tr('attachPhoto'),
                            onPressed: () => _pickImage(camera: false),
                            icon: const Icon(Icons.image_outlined),
                          ),
                          IconButton(
                            tooltip: context.tr('takePhoto'),
                            onPressed: () => _pickImage(camera: true),
                            icon: const Icon(Icons.camera_alt_outlined),
                          ),
                        ],
                        Expanded(
                          child: TextField(
                            key: const ValueKey('chat-composer'),
                            controller: _draft,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendDraft(),
                            decoration: InputDecoration(
                              hintText: context.tr('messagesHint'),
                              isDense: true,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: context.tr('send'),
                          onPressed: _sendDraft,
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                  if (widget.onSendVoice != null)
                    VoiceNoteRecorderButton(onRecorded: widget.onSendVoice!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final NeighborMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = mine
        ? (isDark ? const Color(0xFF8B1A1A) : WidzewColors.redSoft)
        : (isDark ? const Color(0xFF2A2A2A) : WidzewColors.chipFill);
    final ink = isDark ? Colors.white : WidzewColors.ink;
    return RepaintBoundary(
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: ink, fontSize: 15, height: 1.35),
            child: Column(
              crossAxisAlignment: mine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (message.isVoice)
                  SizedBox(
                    width: 240,
                    child: VoiceNotePlayer(
                      durationSeconds: message.durationSeconds == 0
                          ? 4
                          : message.durationSeconds,
                      audioPath: message.audioPath,
                    ),
                  )
                else if (message.isImage && !kIsWeb) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(message.imagePath!),
                      width: 220,
                      height: 160,
                      cacheWidth: WidzewUi.imageCachePixels(context, 220),
                      cacheHeight: WidzewUi.imageCachePixels(context, 160),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox(
                        width: 220,
                        height: 120,
                        child: Icon(Icons.broken_image_outlined, size: 40),
                      ),
                    ),
                  ),
                  if (message.text.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(message.text),
                  ],
                ] else
                  Text(message.text),
                const SizedBox(height: 4),
                Text(
                  message.isVoice
                      ? '${context.tr('audioNote')} · ${message.status.label}'
                      : message.status.label,
                  style: TextStyle(
                    color: ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
