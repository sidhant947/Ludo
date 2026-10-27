import 'package:flame_audio/flame_audio.dart';
import 'storage_service.dart';

class AudioService {
  static const double _menuVolume = 0.5;
  static bool _isGameplay = false;
  static bool _enabled = true;
  static AudioPlayer? _dicePlayer;

  static bool get isEnabled => _enabled;
  static bool get isGameplay => _isGameplay;

  static Future<void> init() async {
    _enabled = await StorageService.getSoundEnabled();
    try {
      await FlameAudio.bgm.initialize();
      if (_enabled && !_isGameplay) {
        await FlameAudio.bgm.play('bgm.mp3', volume: _menuVolume);
      }
    } catch (_) {}
    await _initDicePlayer();
  }

  static Future<void> _initDicePlayer() async {
    try {
      final player = AudioPlayer()..audioCache = FlameAudio.audioCache;
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setAudioContext(
        AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build(),
      );
      await player.setSource(AssetSource('dice.mp3'));
      _dicePlayer = player;
    } catch (_) {}
  }

  static Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await StorageService.setSoundEnabled(enabled);
    try {
      if (!enabled || _isGameplay) {
        await FlameAudio.bgm.pause();
        await _dicePlayer?.stop();
      } else {
        await FlameAudio.bgm.play('bgm.mp3', volume: _menuVolume);
      }
    } catch (_) {}
  }

  static Future<void> setGameplay(bool inGame) async {
    _isGameplay = inGame;
    if (!_enabled) return;
    try {
      if (inGame) {
        await FlameAudio.bgm.pause();
      } else if (FlameAudio.bgm.audioPlayer.source != null) {
        await FlameAudio.bgm.resume();
      } else {
        await FlameAudio.bgm.play('bgm.mp3', volume: _menuVolume);
      }
    } catch (_) {}
  }

  static Future<void> playDice() async {
    if (!_enabled) return;
    try {
      if (_dicePlayer == null) {
        await _initDicePlayer();
      }
      await _dicePlayer?.stop();
      await _dicePlayer?.resume();
    } catch (_) {
      try {
        await _dicePlayer?.play(AssetSource('dice.mp3'), volume: 1.0);
      } catch (_) {}
    }
  }

  static Future<void> dispose() async {
    try {
      await _dicePlayer?.dispose();
      _dicePlayer = null;
      await FlameAudio.bgm.dispose();
    } catch (_) {}
  }
}
