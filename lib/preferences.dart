import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences _preferences;
  static const SCORE_KEY = 'bestScore';

  init() async {
    if (_preferences == null) {
      _preferences= await SharedPreferences.getInstance();
    }
  }

  int get bestScore => _preferences.getInt(SCORE_KEY) ?? 0;

  set bestScore(int value) { _preferences.setInt(SCORE_KEY, value); }
}

final preferences = Preferences();