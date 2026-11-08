import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../l10n/app_localizations.dart';
import '../utils/flutter_runtime.dart';

class VoiceNoteResult {
  final int durationSeconds;
  final String? audioPath;

  const VoiceNoteResult({
    required this.durationSeconds,
    this.audioPath,
  });
}

class VoiceNotePlayer extends StatefulWidget {
  final int durationSeconds;
  final String? audioPath;
  final bool compact;

  const VoiceNotePlayer({
    super.key,
    required this.durationSeconds,
    this.audioPath,
    this.compact = false,
  });

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  AudioPlayer? _player;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<void>? _completeSub;
  var _playing = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool get _hasFile {
    final path = widget.audioPath;
    if (kIsWeb || path == null || path.isEmpty) return false;
    return File(path).existsSync();
  }

  @override
  void initState() {
    super.initState();
    final seconds = widget.durationSeconds.clamp(1, 60);
    _duration = Duration(seconds: seconds);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: seconds),
    );
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _completeSub?.cancel();
    unawaited(_player?.dispose());
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ensurePlayer() async {
    if (_player != null) return;
    final player = AudioPlayer();
    _player = player;
    _positionSub = player.onPositionChanged.listen((position) {
      if (mounted) setState(() => _position = position);
    });
    _durationSub = player.onDurationChanged.listen((duration) {
      if (!mounted || duration.inMilliseconds <= 0) return;
      setState(() => _duration = duration);
    });
    _completeSub = player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _playing = false;
        _position = Duration.zero;
      });
    });
  }

  Future<void> _toggle() async {
    if (_hasFile) {
      await _toggleFile();
      return;
    }
    if (_controller.isAnimating) {
      _controller.stop();
      setState(() {});
      return;
    }
    if (_controller.isCompleted) {
      _controller.reset();
    }
    _controller.forward().whenComplete(() {
      if (mounted) setState(() {});
    });
    setState(() {});
  }

  Future<void> _toggleFile() async {
    await _ensurePlayer();
    final player = _player;
    final path = widget.audioPath;
    if (player == null || path == null) return;
    if (_playing) {
      await player.pause();
      if (mounted) setState(() => _playing = false);
      return;
    }
    final total = _duration.inMilliseconds;
    if (total > 0 && _position.inMilliseconds >= total) {
      await player.seek(Duration.zero);
      _position = Duration.zero;
    }
    await player.play(DeviceFileSource(path));
    if (mounted) setState(() => _playing = true);
  }

  @override
  Widget build(BuildContext context) {
    final playing = _hasFile ? _playing : _controller.isAnimating;
    final progress = _hasFile
        ? (_duration.inMilliseconds == 0
              ? 0.0
              : (_position.inMilliseconds / _duration.inMilliseconds).clamp(
                  0.0,
                  1.0,
                ))
        : null;
    return Row(
      mainAxisSize: widget.compact ? MainAxisSize.max : MainAxisSize.min,
      children: [
        IconButton(
          tooltip: playing
              ? context.tr('pauseVoice')
              : context.tr('playVoice'),
          onPressed: () => unawaited(_toggle()),
          icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
        ),
        Expanded(
          child: progress == null
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => _VoiceProgress(
                    value: _controller.value,
                    label: '${widget.durationSeconds} s',
                  ),
                )
              : _VoiceProgress(
                  value: progress,
                  label: '${widget.durationSeconds} s',
                ),
        ),
      ],
    );
  }
}

class _VoiceProgress extends StatelessWidget {
  final double value;
  final String label;

  const _VoiceProgress({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: value),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class VoiceNoteRecorderButton extends StatefulWidget {
  final ValueChanged<VoiceNoteResult> onRecorded;

  const VoiceNoteRecorderButton({super.key, required this.onRecorded});

  @override
  State<VoiceNoteRecorderButton> createState() =>
      _VoiceNoteRecorderButtonState();
}

class _VoiceNoteRecorderButtonState extends State<VoiceNoteRecorderButton> {
  static const _maxSeconds = 60;
  AudioRecorder? _recorder;
  Timer? _ticker;
  DateTime? _startedAt;
  var _recording = false;
  var _hold = false;
  var _elapsed = 0;
  DateTime _ignoreTapUntil = DateTime.fromMillisecondsSinceEpoch(0);
  String? _path;

  @override
  void dispose() {
    _ticker?.cancel();
    final recorder = _recorder;
    if (recorder != null) {
      unawaited(() async {
        try {
          if (await recorder.isRecording()) await recorder.cancel();
        } catch (_) {}
        await recorder.dispose();
      }());
    }
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_hold || DateTime.now().isBefore(_ignoreTapUntil)) return;
    if (_recording) {
      await _stopAndSend();
      return;
    }
    await _start();
  }

  Future<void> _start() async {
    if (_recording) return;
    if (isFlutterWidgetTest) {
      setState(() {
        _recording = true;
        _elapsed = 0;
      });
      await Future<void>.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      setState(() => _recording = false);
      widget.onRecorded(const VoiceNoteResult(durationSeconds: 4));
      return;
    }

    try {
      _recorder ??= AudioRecorder();
      final allowed = await _recorder!.hasPermission();
      if (!allowed) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('micPermissionDenied'))),
        );
        return;
      }
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}${Platform.pathSeparator}voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder!.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
        path: path,
      );
      _path = path;
      _startedAt = DateTime.now();
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        final seconds = DateTime.now().difference(_startedAt!).inSeconds;
        setState(() => _elapsed = seconds);
        if (seconds >= _maxSeconds) {
          unawaited(_stopAndSend());
        }
      });
      if (!mounted) return;
      setState(() {
        _recording = true;
        _elapsed = 0;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _recording = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('micPermissionDenied'))),
      );
    }
  }

  Future<void> _stopAndSend() async {
    if (!_recording) return;
    _ticker?.cancel();
    var seconds = _startedAt == null
        ? 1
        : DateTime.now().difference(_startedAt!).inSeconds;
    if (seconds < 1) seconds = 1;
    if (seconds > _maxSeconds) seconds = _maxSeconds;
    String? path = _path;
    try {
      path = await _recorder?.stop() ?? path;
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _recording = false;
      _hold = false;
      _elapsed = 0;
    });
    widget.onRecorded(
      VoiceNoteResult(durationSeconds: seconds, audioPath: path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_recording)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: LinearProgressIndicator(
              value: (_elapsed / _maxSeconds).clamp(0.0, 1.0),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onLongPressStart: (_) {
                _hold = true;
                unawaited(_start());
              },
              onLongPressEnd: (_) {
                _hold = false;
                _ignoreTapUntil = DateTime.now().add(
                  const Duration(milliseconds: 400),
                );
                unawaited(_stopAndSend());
              },
              child: FilledButton.tonalIcon(
                onPressed: () => unawaited(_toggle()),
                icon: Icon(_recording ? Icons.mic : Icons.mic_none),
                label: Text(
                  _recording
                      ? '${context.tr('recordingVoice')} ($_elapsed s)'
                      : context.tr('voiceRecord'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
