import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/full_screen_utils.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_artwork.dart';

/// پخش‌کنندهٔ واقعی ویدئو. وضعیت تماشا به‌صورت درصد و تنها روی دستگاه کاربر
/// ذخیره می‌شود تا ادامهٔ تماشا در صفحهٔ اصلی در دسترس باشد.
class PlayerPage extends ConsumerStatefulWidget {
  const PlayerPage({
    super.key,
    required this.cartoon,
    required this.episode,
  });

  final CartoonModel cartoon;
  final EpisodeModel episode;

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> {
  VideoPlayerController? _videoController;
  Timer? _controlsTimer;
  DateTime _lastUiUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  double _lastSavedProgress = 0;
  bool _showControls = true;
  bool _isLoading = true;
  String? _errorMessage;
  Brightness _returnBrightness = Brightness.light;
  late final WatchHistoryNotifier _historyNotifier;

  @override
  void initState() {
    super.initState();
    _historyNotifier = ref.read(watchHistoryProvider.notifier);
    unawaited(FullScreenUtils.enablePlayerMode());
    unawaited(_initializePlayer());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _returnBrightness = Theme.of(context).brightness;
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _saveCurrentProgress();
    _videoController?.removeListener(_onVideoChanged);
    _videoController?.dispose();
    unawaited(WakelockPlus.disable());
    unawaited(FullScreenUtils.restoreAppMode(_returnBrightness));
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    final source = widget.episode.videoUrl.trim();
    if (source.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'برای این قسمت هنوز آدرس ویدئوی قابل پخش ثبت نشده است.';
        });
      }
      return;
    }

    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.networkUrl(Uri.parse(source));
      controller.addListener(_onVideoChanged);
      await controller.initialize();
      if (!mounted) {
        controller.removeListener(_onVideoChanged);
        await controller.dispose();
        return;
      }
      if (controller.value.hasError) {
        throw StateError(controller.value.errorDescription ?? 'خطا در آماده‌سازی ویدئو');
      }
      _videoController = controller;

      final savedProgress = ref.read(episodeProgressProvider(widget.episode.id));
      _lastSavedProgress = savedProgress;
      if (savedProgress > .01) {
        final milliseconds =
            (controller.value.duration.inMilliseconds * savedProgress).round();
        await controller.seekTo(Duration(milliseconds: milliseconds));
      }
      if (ref.read(autoplayProvider)) {
        await controller.play();
        unawaited(WakelockPlus.enable());
        _scheduleControlsHide();
      }
      if (mounted) setState(() => _isLoading = false);
    } catch (_) {
      controller?.removeListener(_onVideoChanged);
      if (controller != null) await controller.dispose();
      if (identical(_videoController, controller)) _videoController = null;
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'ویدئو باز نشد. اتصال اینترنت یا آدرس فایل را بررسی کنید.';
        });
      }
    }
  }

  void _onVideoChanged() {
    if (!mounted) return;
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;
    final duration = controller.value.duration;
    if (duration.inMilliseconds <= 0) return;

    final progress = (controller.value.position.inMilliseconds / duration.inMilliseconds)
        .clamp(0.0, 1.0)
        .toDouble();
    if ((progress - _lastSavedProgress).abs() >= .02 || progress >= .995) {
      _lastSavedProgress = progress;
      _historyNotifier.saveProgress(widget.episode.id, progress);
    }

    final now = DateTime.now();
    if (mounted && now.difference(_lastUiUpdate) >= const Duration(milliseconds: 450)) {
      _lastUiUpdate = now;
      setState(() {});
    }
  }

  void _saveCurrentProgress() {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;
    final duration = controller.value.duration;
    if (duration.inMilliseconds <= 0) return;
    final progress = (controller.value.position.inMilliseconds / duration.inMilliseconds)
        .clamp(0.0, 1.0)
        .toDouble();
    _historyNotifier.saveProgress(widget.episode.id, progress);
  }

  Future<void> _retry() async {
    final oldController = _videoController;
    oldController?.removeListener(_onVideoChanged);
    if (oldController != null) await oldController.dispose();
    _videoController = null;
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _showControls = true;
    });
    await _initializePlayer();
  }

  void _toggleControls() {
    if (_isLoading || _errorMessage != null) return;
    setState(() => _showControls = !_showControls);
    if (_showControls) _scheduleControlsHide();
  }

  void _scheduleControlsHide() {
    _controlsTimer?.cancel();
    final controller = _videoController;
    if (controller?.value.isPlaying != true) return;
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _videoController?.value.isPlaying == true) {
        setState(() => _showControls = false);
      }
    });
  }

  Future<void> _togglePlay() async {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;
    HapticFeedback.mediumImpact();
    if (controller.value.isPlaying) {
      await controller.pause();
      unawaited(WakelockPlus.disable());
      _controlsTimer?.cancel();
      if (mounted) setState(() => _showControls = true);
    } else {
      await controller.play();
      unawaited(WakelockPlus.enable());
      if (mounted) setState(() => _showControls = true);
      _scheduleControlsHide();
    }
  }

  Future<void> _seekBy(int seconds) async {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;
    final targetMilliseconds =
        controller.value.position.inMilliseconds + (seconds * 1000);
    final safeMilliseconds = targetMilliseconds
        .clamp(0, controller.value.duration.inMilliseconds)
        .toInt();
    await controller.seekTo(Duration(milliseconds: safeMilliseconds));
    _scheduleControlsHide();
  }

  Future<void> _seekTo(double value) async {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;
    await controller.seekTo(
      Duration(milliseconds: (controller.value.duration.inMilliseconds * value).round()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _videoController;
    final ready = controller?.value.isInitialized == true;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Opacity(
                  opacity: .36,
                  child: CartoonArtwork(
                    cartoon: widget.cartoon,
                    borderRadius: 0,
                    showPlayAffordance: false,
                  ),
                ),
              ),
              const ColoredBox(color: Color(0x55000000)),
              if (ready)
                Center(
                  child: AspectRatio(
                    aspectRatio: controller!.value.aspectRatio <= 0
                        ? 16 / 9
                        : controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              if (_isLoading) const _PlayerLoading(),
              if (_errorMessage != null)
                _PlayerError(
                  message: _errorMessage!,
                  onRetry: () => unawaited(_retry()),
                ),
              if (ready && _errorMessage == null) ...[
                _PlayerTopBar(
                  title: '${widget.cartoon.title} · ${widget.episode.title}',
                  visible: _showControls,
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                _PlayerCenterControl(
                  isPlaying: controller!.value.isPlaying,
                  visible: _showControls || !controller.value.isPlaying,
                  onPressed: () => unawaited(_togglePlay()),
                ),
                _PlayerBottomControls(
                  controller: controller,
                  visible: _showControls,
                  onTogglePlay: () => unawaited(_togglePlay()),
                  onSeekBack: () => unawaited(_seekBy(-10)),
                  onSeekForward: () => unawaited(_seekBy(10)),
                  onSeek: (value) => unawaited(_seekTo(value)),
                  onStartSeek: () => _controlsTimer?.cancel(),
                  onEndSeek: _scheduleControlsHide,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerLoading extends StatelessWidget {
  const _PlayerLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 14),
          Text('در حال آماده‌سازی ویدئو…', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _PlayerError extends StatelessWidget {
  const _PlayerError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.64),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_disabled_rounded, color: Colors.white, size: 44),
                const SizedBox(height: 13),
                const Text(
                  'پخش ویدئو ممکن نشد',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 7),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('تلاش دوباره'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('بازگشت', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerTopBar extends StatelessWidget {
  const _PlayerTopBar({
    required this.title,
    required this.visible,
    required this.onBack,
  });

  final String title;
  final bool visible;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 180),
      child: IgnorePointer(
        ignoring: !visible,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'بستن پخش‌کننده',
                  onPressed: onBack,
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  style: IconButton.styleFrom(backgroundColor: Colors.black38),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

class _PlayerCenterControl extends StatelessWidget {
  const _PlayerCenterControl({
    required this.isPlaying,
    required this.visible,
    required this.onPressed,
  });

  final bool isPlaying;
  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedScale(
        scale: visible ? 1 : .75,
        duration: const Duration(milliseconds: 180),
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 180),
          child: IgnorePointer(
            ignoring: !visible,
            child: IconButton.filled(
              tooltip: isPlaying ? 'توقف' : 'پخش',
              onPressed: onPressed,
              iconSize: 46,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(76, 76),
              ),
              icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerBottomControls extends StatelessWidget {
  const _PlayerBottomControls({
    required this.controller,
    required this.visible,
    required this.onTogglePlay,
    required this.onSeekBack,
    required this.onSeekForward,
    required this.onSeek,
    required this.onStartSeek,
    required this.onEndSeek,
  });

  final VideoPlayerController controller;
  final bool visible;
  final VoidCallback onTogglePlay;
  final VoidCallback onSeekBack;
  final VoidCallback onSeekForward;
  final ValueChanged<double> onSeek;
  final VoidCallback onStartSeek;
  final VoidCallback onEndSeek;

  @override
  Widget build(BuildContext context) {
    final duration = controller.value.duration;
    final position = controller.value.position.inMilliseconds > duration.inMilliseconds
        ? duration
        : controller.value.position;
    final value = duration.inMilliseconds == 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0).toDouble();

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        child: IgnorePointer(
          ignoring: !visible,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 28, 18, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(_formatDuration(position), style: const TextStyle(color: Colors.white70)),
                        Expanded(
                          child: Slider(
                            value: value,
                            activeColor: AppColors.primary,
                            inactiveColor: Colors.white30,
                            onChangeStart: (_) => onStartSeek(),
                            onChanged: onSeek,
                            onChangeEnd: (_) => onEndSeek(),
                          ),
                        ),
                        Text(_formatDuration(duration), style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          tooltip: '۱۰ ثانیه جلو',
                          onPressed: onSeekForward,
                          icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        IconButton.filled(
                          tooltip: controller.value.isPlaying ? 'توقف' : 'پخش',
                          onPressed: onTogglePlay,
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          icon: Icon(
                            controller.value.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          tooltip: '۱۰ ثانیه عقب',
                          onPressed: onSeekBack,
                          icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDuration(Duration value) {
  final minutes = value.inMinutes;
  final seconds = value.inSeconds.remainder(60);
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
