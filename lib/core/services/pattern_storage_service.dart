import 'package:shared_preferences/shared_preferences.dart';

class PatternStorageService {
  Future<void> savePattern(List<int> pattern) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pattern', pattern.map((e) => e.toString()).toList());
  }

  Future<List<int>?> getPattern() async {
    final prefs = await SharedPreferences.getInstance();
    final patternStrings = prefs.getStringList('pattern');
    if (patternStrings != null) {
      return patternStrings.map((e) => int.parse(e)).toList();
    }
    return null;
  }

  Future<bool> isPatternSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('pattern');
  }

  Future<void> clearPattern() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pattern');
  }
}
