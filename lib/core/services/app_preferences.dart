import 'package:shared_preferences/shared_preferences.dart';

abstract final class AppPreferences {
  static const String onboardingCompletedKey = 'onboarding_completed';

  static Future<bool> isOnboardingCompleted() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getBool(onboardingCompletedKey) ?? false;
  }

  static Future<void> completeOnboarding() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setBool(onboardingCompletedKey, true);
  }
}
