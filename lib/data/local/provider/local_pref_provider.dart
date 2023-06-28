import 'package:shared_preferences/shared_preferences.dart';

class LocalPrefProvider {
  late SharedPreferences prefs;

  final showOnBoarding = "onboarding";

  void setShowOnBoarding(bool bool) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(showOnBoarding, bool);
  }

  Future<bool> getShowOnBoarding() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool(showOnBoarding) ?? true;
  }
}
