import 'package:flutter/services.dart';

abstract final class HapticService {
  static Future<void> light() {
    return HapticFeedback.lightImpact();
  }

  static Future<void> selection() {
    return HapticFeedback.selectionClick();
  }

  static Future<void> medium() {
    return HapticFeedback.mediumImpact();
  }

  static Future<void> heavy() {
    return HapticFeedback.heavyImpact();
  }
}
