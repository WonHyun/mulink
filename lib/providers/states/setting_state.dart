import 'package:flutter/material.dart';

class SettingState {
  final ThemeMode themeMode;
  SettingState({required this.themeMode});
  SettingState copyWith({
    ThemeMode? themeMode,
  }) {
    return SettingState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
