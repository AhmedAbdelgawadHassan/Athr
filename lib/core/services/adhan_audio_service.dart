import 'package:audioplayers/audioplayers.dart';

class AdhanAudioService {
  static final AdhanAudioService _instance = AdhanAudioService._internal();
  factory AdhanAudioService() => _instance;
  AdhanAudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  Future<void> init() async {
    await _player.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.alarm,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
      ),
    );

    _player.onPlayerComplete.listen((_) async {
      _isPlaying = false;
    });
  }

  Future<void> playAdhan() async {
    if (_isPlaying) await stopAdhan();
    _isPlaying = true;
    await _player.play(AssetSource('audio/adhan.mp3'));
  }

  Future<void> stopAdhan() async {
    if (!_isPlaying) return;
    await _player.stop();
    _isPlaying = false;
  }

  void dispose() {
    _player.dispose();
  }
}