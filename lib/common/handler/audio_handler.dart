import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHandler {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> play(String url) async {
    await _player.stop(); 
    await _player.play(UrlSource(url));
  }

  static Future<void> pause() async {
    await _player.pause();
  }

  static Future<void> resume() async {
    await _player.resume();
  }

  static Future<void> stop() async {
    await _player.stop();
  }

  static AudioPlayer get player => _player;
}
