import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static Future<List<String>> getSpList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static setSpList(String key, List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, list);
  }
}