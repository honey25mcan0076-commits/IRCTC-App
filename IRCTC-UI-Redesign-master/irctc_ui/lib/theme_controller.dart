import 'package:flutter/material.dart';

class AppThemeController extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  ThemeMode get themeMode =>
      _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void setDark() {
    if (!_isDark) {
      _isDark = true;
      notifyListeners();
    }
  }

  void setLight() {
    if (_isDark) {
      _isDark = false;
      notifyListeners();
    }
  }
}

final AppThemeController appThemeController =
    AppThemeController();