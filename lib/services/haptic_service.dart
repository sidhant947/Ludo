import 'package:flutter/services.dart';
import 'storage_service.dart';

class HapticService {
  static bool _enabled = true;

  static bool get isEnabled => _enabled;

  static Future<void> init() async {
    _enabled = await StorageService.getHapticFeedback();
  }

  static Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await StorageService.setHapticFeedback(enabled);
    if (enabled) {
      HapticFeedback.mediumImpact();
    }
  }

  static void light() {
    if (_enabled) {
      HapticFeedback.lightImpact();
    }
  }

  static void medium() {
    if (_enabled) {
      HapticFeedback.mediumImpact();
    }
  }

  static void heavy() {
    if (_enabled) {
      HapticFeedback.heavyImpact();
    }
  }

  static void selection() {
    if (_enabled) {
      HapticFeedback.selectionClick();
    }
  }

  static void vibrate() {
    if (_enabled) {
      HapticFeedback.vibrate();
    }
  }
}
