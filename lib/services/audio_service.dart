import 'package:flame_audio/flame_audio.dart';
import 'storage_service.dart';

class AudioService {
  static const double _menuVolume = 0.5;
  static const double _gameplayVolume = 0.18;
  static bool _isGameplay = false;
  static bool _enabled = true;

  static bool get isEnabled => _enabled;

  static Future<void> init() async {
    _enabled = await StorageService.getSoundEnabled();
    try {
      await FlameAudio.bgm.initialize();
      if (_enabled) {
        await FlameAudio.bgm.play(
          'bgm.mp3',
          volume: _isGameplay ? _gameplayVolume : _menuVolume,
        );
      }
    } catch (_) {}
  }

  static Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await StorageService.setSoundEnabled(enabled);
    try {
      if (!enabled) {
        await FlameAudio.bgm.pause();
      } else {
        await FlameAudio.bgm.play(
          'bgm.mp3',
          volume: _isGameplay ? _gameplayVolume : _menuVolume,
        );
      }
    } catch (_) {}
  }

  static Future<void> setGameplay(bool inGame) async {
    _isGameplay = inGame;
    if (!_enabled) return;
    try {
      await FlameAudio.bgm.audioPlayer.setVolume(
        inGame ? _gameplayVolume : _menuVolume,
      );
    } catch (_) {}
  }

  static Future<void> playDice() async {
    if (!_enabled) return;
    try {
      await FlameAudio.play('dice.mp3', volume: 1.0);
    } catch (_) {}
  }
}
