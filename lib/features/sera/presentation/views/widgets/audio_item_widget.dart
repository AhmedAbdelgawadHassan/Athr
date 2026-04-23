// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'dart:ui';

class AudioItemWidget extends StatefulWidget {
  const AudioItemWidget({super.key, required this.seraAudioModel});

  final dynamic seraAudioModel; // تأكد من استيراد SeraAudioModel الخاص بك

  @override
  State<AudioItemWidget> createState() => _AudioItemWidgetState();
}

class _AudioItemWidgetState extends State<AudioItemWidget> {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  bool isDownloading = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() => isPlaying = false);
        player.seek(Duration.zero);
        player.pause();
      }
    });
    player.positionStream.listen((p) => setState(() => position = p));
    player.durationStream.listen((d) {
      if (d != null) setState(() => duration = d);
    });
  }

  Future<void> togglePlay() async {
    if (player.audioSource == null) {
      await player.setUrl(widget.seraAudioModel.url);
    }
    isPlaying ? await player.pause() : player.play();
    setState(() => isPlaying = !isPlaying);
  }

  void seekRelative(int seconds) {
    final newPos = position + Duration(seconds: seconds);
    player.seek(newPos < Duration.zero
        ? Duration.zero
        : newPos > duration
            ? duration
            : newPos);
  }

  // --- منطق الصلاحيات والتحميل ---
  Future<void> handleDownload() async {
    // 1. طلب الصلاحية
    PermissionStatus status;
    if (Platform.isAndroid) {
      // لأندرويد 13 فما فوق نستخدم photos/videos أو المسار العام
      status = await Permission.storage.request();
      if (status.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      await startDownload();
    } else {
      _showCustomAlert(
          "تنبيه",
          "نحتاج لصلاحية الوصول للتخزين لنتمكن من حفظ الملف.",
          Icons.warning_amber_rounded,
          Colors.orange);
    }
  }

  Future<void> startDownload() async {
    setState(() => isDownloading = true);
    try {
      final dir =
          await getExternalStorageDirectory(); // أو getApplicationDocumentsDirectory
      final filePath =
          "${dir!.path}/${widget.seraAudioModel.title.replaceAll(' ', '_')}.mp3";

      await Dio().download(widget.seraAudioModel.url, filePath);

      setState(() => widget.seraAudioModel.isDownloaded = true);
      _showCustomAlert("تم بنجاح", "تم حفظ المقطع الصوتي في جهازك بنجاح!",
          Icons.check_circle_outline_rounded, Colors.green);
    } catch (e) {
      _showCustomAlert("خطأ", "حدث خطأ أثناء التحميل، تأكد من اتصال الإنترنت.",
          Icons.error_outline_rounded, Colors.red);
    } finally {
      setState(() => isDownloading = false);
    }
  }

  // --- رسالة تنبيه مخصصة وأنيقة ---
  void _showCustomAlert(
      String title, String message, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.9),
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Text(title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(message, style: const TextStyle(color: Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // خلفية الصورة
            Positioned.fill(
              child:
                  Image.asset(widget.seraAudioModel.image, fit: BoxFit.cover),
            ),
            // تدرج لوني جمالي
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.85)
                    ],
                  ),
                ),
              ),
            ),
            // المحتوى
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(" ${widget.seraAudioModel.number}  - ${widget.seraAudioModel.title }",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const Text("سيرة عطرة",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      _buildDownloadButton(),
                    ],
                  ),
                  const Spacer(),
                  // أزرار التحكم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _controlIcon(
                          Icons.replay_10_rounded, () => seekRelative(-10)),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: togglePlay,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.black,
                              size: 35),
                        ),
                      ),
                      const SizedBox(width: 25),
                      _controlIcon(
                          Icons.forward_10_rounded, () => seekRelative(10)),
                    ],
                  ),
                  const Spacer(),
                  _buildSlider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    if (isDownloading) {
      return const SizedBox(
          height: 24,
          width: 24,
          child:
              CircularProgressIndicator(strokeWidth: 2, color: Colors.white));
    }
    return IconButton(
      onPressed: widget.seraAudioModel.isDownloaded ? null : handleDownload,
      icon: Icon(
        widget.seraAudioModel.isDownloaded
            ? Icons.cloud_done_rounded
            : Icons.cloud_download_rounded,
        color: widget.seraAudioModel.isDownloaded
            ? Colors.greenAccent
            : Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            activeTrackColor: Colors.amber,
            inactiveTrackColor: Colors.white30,
            thumbColor: Colors.amber,
          ),
          child: Slider(
            value: position.inMilliseconds.toDouble(),
            max: duration.inMilliseconds.toDouble() <= 0
                ? 1.0
                : duration.inMilliseconds.toDouble(),
            onChanged: (v) => player.seek(Duration(milliseconds: v.toInt())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(position),
                  style: const TextStyle(color: Colors.white60, fontSize: 10)),
              Text(_formatDuration(duration),
                  style: const TextStyle(color: Colors.white60, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _controlIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }

  String _formatDuration(Duration d) =>
      "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
}
