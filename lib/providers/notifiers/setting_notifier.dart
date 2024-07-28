import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/states/setting_state.dart';

class SettingNotifier extends Notifier<SettingState> {
  @override
  SettingState build() {
    return SettingState(
      themeMode: ThemeMode.dark,
    );
  }

  void toggleThemeMode() {
    state = state.copyWith(
      themeMode:
          state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

final settingProvider = NotifierProvider<SettingNotifier, SettingState>(
  () => SettingNotifier(),
);
