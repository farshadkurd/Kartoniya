// lib/presentation/pages/player_page.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/full_screen_utils.dart';
import '../../data/models/cartoon_model.dart';

/// ▶️ صفحه پخش ویدیو با کنترل‌های زیبا
class PlayerPage extends StatefulWidget {
  final CartoonModel cartoon;

  const PlayerPage({super.key, required this.cartoon});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with TickerProviderStateMixin {
  bool _showControls = true;
  bool _isPlaying = false;
  double _progress = 0.0;
  Timer? _hideTimer;
  Timer? _progressTimer;
  late AnimationController _controlsController;
  late Animation<double> _controlsOpacity;
  late AnimationController _playPauseController;

  // شبیه‌سازی زمان پخش
  int _currentSeconds = 0;
  late int _totalSeconds;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.cartoon.duration * 60;

    FullScreenUtils.enableFullScreen();
    try {
      WakelockPlus.enable();
    } catch (_) {}

    // کنترلر نمایش کنترل‌ها
    _controlsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controlsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controlsController, curve: Curves.easeOut),
    );
    _controlsController.forward();

    // کنترلر پخش/توقف
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // شروع خودکار پخش
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isPlaying = true);
        _startProgressSimulation();
        _startHideTimer();
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _progressTimer?.cancel();
    _controlsController.dispose();
    _playPauseController.dispose();
    FullScreenUtils.disableFullScreen();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    super.dispose();
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _controlsController.forward();
      _startHideTimer();
    } else {
      _controlsController.reverse();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _isPlaying) {
        setState(() => _showControls = false);
        _controlsController.reverse();
      }
    });
  }

  void _startProgressSimulation() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isPlaying) {
        setState(() {
          _currentSeconds++;
          if (_currentSeconds >= _totalSeconds) {
            _currentSeconds = 0;
          }
          _progress = _currentSeconds / _totalSeconds;
        });
      }
    });
  }

  void _togglePlayPause() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _playPauseController.reverse();
      _startProgressSimulation();
      _startHideTimer();
    } else {
      _playPauseController.forward();
      _progressTimer?.cancel();
      _hideTimer?.cancel();
      setState(() => _showControls = true);
      _controlsController.forward();
    }
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // پس‌زمینه ویدیو (تصویر ثابت به عنوان فریم)
              Image.network(
                widget.cartoon.thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (c, e, s) => Container(
                  color: Colors.black87,
                  child: const Center(
                    child: Icon(
                      Icons.movie_rounded,
                      size: 80,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),

              // گرادیان بالا
              AnimatedBuilder(
                animation: _controlsOpacity,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controlsOpacity.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // گرادیان پایین
              AnimatedBuilder(
                animation: _controlsOpacity,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controlsOpacity.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // نوار بالایی
              if (_showControls)
                AnimatedBuilder(
                  animation: _controlsOpacity,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controlsOpacity.value,
                      child: child,
                    );
                  },
                  child: Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.cartoon.title,
                            style: TextStyle(
                              fontFamily: GoogleFonts.vazirmatn().fontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // دکمه پخش بزرگ وسط
              Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: AnimatedBuilder(
                    animation: _isPlaying
                        ? _playPauseController
                        : const AlwaysStoppedAnimation(1.0),
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            _isPlaying ? 0.0 : 0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: _isPlaying ? 0 : 60,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // نوار پایینی (کنترل‌ها)
              if (_showControls)
                AnimatedBuilder(
                  animation: _controlsOpacity,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controlsOpacity.value,
                      child: child,
                    );
                  },
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: MediaQuery.of(context).padding.bottom + 16,
                        top: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // نوار پیشرفت
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.primary.withOpacity(0.1),
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7,
                              ),
                            ),
                            child: Slider(
                              value: _progress,
                              onChanged: (value) {
                                setState(() {
                                  _progress = value;
                                  _currentSeconds =
                                      (value * _totalSeconds).round();
                                });
                              },
                              onChangeEnd: (_) {
                                if (_isPlaying) _startHideTimer();
                              },
                            ),
                          ),

                          // زمان
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  _formatTime(_currentSeconds),
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.vazirmatn().fontFamily,
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _formatTime(_totalSeconds),
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.vazirmatn().fontFamily,
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // دکمه‌های کنترل
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // قسمت قبلی
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.skip_previous_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 24),

                              // دکمه پخش/توقف
                              GestureDetector(
                                onTap: _togglePlayPause,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.sunsetGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 24),

                              // قسمت بعدی
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.skip_next_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
