// lib/core/services/adhan_audio_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AdhanAudioService {
  static final AdhanAudioService _instance = AdhanAudioService._internal();
  factory AdhanAudioService() => _instance;
  AdhanAudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _player.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.alarm,
            audioFocus: AndroidAudioFocus.gain,
          ),
          // ✅ حذف defaultToSpeaker - مش مسموح إلا مع playAndRecord
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {AVAudioSessionOptions.mixWithOthers},
          ),
        ),
      );

      _player.onPlayerComplete.listen((_) {
        _isPlaying = false;
        debugPrint('✅ Adhan complete');
      });

      _isInitialized = true;
      debugPrint('✅ AdhanAudioService initialized');
    } catch (e) {
      debugPrint('❌ AdhanAudioService init error: $e');
      // حتى لو فشل الـ init، نفضل نحاول نشغل
      _isInitialized = true;
    }
  }

  Future<void> playAdhan() async {
    try {
      if (!_isInitialized) await init();
      if (_isPlaying) await stopAdhan();
      _isPlaying = true;
      await _player.play(AssetSource('audio/adhan.mp3'));
      debugPrint('▶️ Adhan playing');
    } catch (e) {
      _isPlaying = false;
      debugPrint('❌ playAdhan error: $e');
    }
  }

  Future<void> stopAdhan() async {
    try {
      await _player.stop();
      _isPlaying = false;
      debugPrint('⏹️ Adhan stopped');
    } catch (e) {
      debugPrint('❌ stopAdhan error: $e');
    }
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _player.dispose();
  }
}