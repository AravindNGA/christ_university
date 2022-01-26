import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class preferencesShared {

  static SharedPreferences? prefs;

  static Future init() async => prefs = await SharedPreferences.getInstance();

  static String? getSavedString(String prefTitle) => prefs!.getString(prefTitle);

  static setSaveAString(String prefTitle, String prefContent) async {
    await prefs!.setString(prefTitle, prefContent);
  }

  static setSaveBooleanState(String prefBoolTitle, bool boolState) async {
    await prefs!.setBool(prefBoolTitle, boolState);
  }

  static bool? getSavedBooleanState(String prefBoolTitle) => prefs!.getBool(prefBoolTitle);
}
