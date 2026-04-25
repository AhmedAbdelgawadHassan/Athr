// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioItemWidget extends StatefulWidget {
  const AudioItemWidget({super.key, required this.seraAudioModel});

  final dynamic seraAudioModel;

  @override
  State<AudioItemWidget> createState() => _AudioItemWidgetState();
}

class _AudioItemWidgetState extends State<AudioItemWidget> {
  final AudioPlayer _player = AudioPlayer();

  final ValueNotifier<Duration> _positionNotifier =
      ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _durationNotifier =
      ValueNotifier(Duration.zero);
  final ValueNotifier<bool> _playingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _downloadingNotifier = ValueNotifier(false);
  final ValueNotifier<double> _downloadProgressNotifier = ValueNotifier(0);

  bool _audioLoaded = false;

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    _player.playerStateStream.listen((state) {
      _playingNotifier.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }
    });

    _player.positionStream.listen((p) => _positionNotifier.value = p);
    _player.durationStream.listen((d) {
      if (d != null) _durationNotifier.value = d;
    });
  }

  // ── تحميل الصوت أول مرة بس ─────────────────────────────
  Future<void> _loadAudioIfNeeded() async {
    if (_audioLoaded) return;
    _loadingNotifier.value = true;
    try {
      await _player.setUrl(widget.seraAudioModel.url);
      _audioLoaded = true;
    } catch (e) {
      _showAlert('خطأ', 'فشل تحميل المقطع', Icons.error, Colors.red);
    } finally {
      _loadingNotifier.value = false;
    }
  }

  // ── تشغيل / إيقاف ──────────────────────────────────────
  Future<void> togglePlay() async {
    await _loadAudioIfNeeded();
    if (!_audioLoaded) return;

    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  // ── تقديم / تأخير ──────────────────────────────────────
  void seekRelative(int seconds) {
    final current = _positionNotifier.value;
    final duration = _durationNotifier.value;
    final newPos = current + Duration(seconds: seconds);
    _player.seek(
      newPos < Duration.zero
          ? Duration.zero
          : newPos > duration
              ? duration
              : newPos,
    );
  }

  // ── تنزيل الملف ────────────────────────────────────────
  Future<void> handleDownload() async {
    // ✅ Android 13+ مش محتاج storage permission
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSdkInt();
      if (sdkInt < 33) {
        final status = await Permission.storage.request();
        if (status.isPermanentlyDenied) {
          openAppSettings();
          return;
        }
        if (!status.isGranted) {
          _showAlert('تنبيه', 'نحتاج صلاحية التخزين',
              Icons.warning_amber_rounded, Colors.orange);
          return;
        }
      }
    }
    await _startDownload();
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      // نرجع 33 افتراضياً لو مش قادر يقرأ
      return 33;
    } catch (_) {
      return 33;
    }
  }

 Future<void> _startDownload() async {
  _downloadingNotifier.value = true;
  _downloadProgressNotifier.value = 0;

  try {
    Directory? dir;
    if (Platform.isAndroid) {
      final paths = [
        '/storage/emulated/0/Download',
        '/storage/emulated/0/Downloads',
        '/sdcard/Download',
      ];

      for (final path in paths) {
        final d = Directory(path);
        final exists = await d.exists();
        print('📁 checking $path → exists: $exists');
        if (exists) {
          dir = d;
          break;
        }
      }

      dir ??= Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) await dir.create(recursive: true);
    }

   final fileName =
    '${widget.seraAudioModel.title.replaceAll(RegExp(r'[<>:"/\\|?*\u0600-\u06FF\s]'), '_')}.mp3';
print('📄 fileName: $fileName');
    final filePath = '${dir!.path}/$fileName';
    print('📥 saving to: $filePath');
    print('🌐 url: ${widget.seraAudioModel.url}');

    await Dio().download(
      widget.seraAudioModel.url,
      filePath,
      onReceiveProgress: (received, total) {
        print('⬇️ progress: $received / $total');
        if (total > 0) _downloadProgressNotifier.value = received / total;
      },
    );

    print('✅ download complete');
    if (mounted) setState(() => widget.seraAudioModel.isDownloaded = true);
    _showAlert('تم بنجاح', 'تم حفظ الملف في Downloads', Icons.check_circle, Colors.green);
  } catch (e) {
    print('❌ download error: $e');
    _showAlert('خطأ', 'فشل التنزيل: $e', Icons.error, Colors.red);
  } finally {
    _downloadingNotifier.value = false;
    _downloadProgressNotifier.value = 0;
  }
}

  // ── Alert ───────────────────────────────────────────────
  void _showAlert(String title, String message, IconData icon, Color color) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.95),
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Text(title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Format Duration ─────────────────────────────────────
  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _player.dispose();
    _positionNotifier.dispose();
    _durationNotifier.dispose();
    _playingNotifier.dispose();
    _loadingNotifier.dispose();
    _downloadingNotifier.dispose();
    _downloadProgressNotifier.dispose();
    super.dispose();
  }

  // ── UI ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            // صورة الخلفية
            Positioned.fill(
              child: Image.asset(
                widget.seraAudioModel.image,
                fit: BoxFit.cover,
              ),
            ),
            // gradient فوق الصورة
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.88),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                children: [
                  // ── العنوان + زرار التنزيل ──
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.seraAudioModel.number} - ${widget.seraAudioModel.title}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildDownloadButton(),
                    ],
                  ),

                  const Spacer(),

                  // ── أزرار التحكم ──
                  ValueListenableBuilder<bool>(
                    valueListenable: _loadingNotifier,
                    builder: (_, isLoading, __) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: _playingNotifier,
                        builder: (_, isPlaying, __) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _controlIcon(
                                  Icons.replay_10, () => seekRelative(-10)),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: isLoading ? null : togglePlay,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 34,
                                          height: 34,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Icon(
                                          isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.black,
                                          size: 34,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              _controlIcon(
                                  Icons.forward_10, () => seekRelative(10)),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // ── الـ Slider + الوقت ──
                  ValueListenableBuilder<Duration>(
                    valueListenable: _positionNotifier,
                    builder: (_, position, __) {
                      return ValueListenableBuilder<Duration>(
                        valueListenable: _durationNotifier,
                        builder: (_, duration, __) {
                          final maxVal = duration.inMilliseconds.toDouble();
                          final curVal = position.inMilliseconds
                              .toDouble()
                              .clamp(0, maxVal <= 0 ? 1 : maxVal);

                          return Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6),
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 12),
                                  trackHeight: 3,
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white30,
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.white24,
                                ),
                                child: Slider(
                                  value: curVal.toDouble(),
                                  max: maxVal <= 0 ? 1 : maxVal,
                                  onChanged: (v) => _player.seek(
                                    Duration(milliseconds: v.toInt()),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_format(position),
                                        style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 11)),
                                    Text(_format(duration),
                                        style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  Widget _buildDownloadButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _downloadingNotifier,
      builder: (_, isDownloading, __) {
        if (isDownloading) {
          return ValueListenableBuilder<double>(
            valueListenable: _downloadProgressNotifier,
            builder: (_, progress, __) {
              return SizedBox(
                width: 36,
                height: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress > 0 ? progress : null,
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                    if (progress > 0)
                      Text(
                        '${(progress * 100).toInt()}%',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 8),
                      ),
                  ],
                ),
              );
            },
          );
        }

        final isDownloaded =
            widget.seraAudioModel.isDownloaded as bool? ?? false;

        return IconButton(
          onPressed: isDownloaded ? null : handleDownload,
          icon: Icon(
            isDownloaded ? Icons.cloud_done : Icons.cloud_download_outlined,
            color: isDownloaded ? Colors.greenAccent : Colors.white,
          ),
        );
      },
    );
  }
}
