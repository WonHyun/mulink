import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mulink/providers/notifiers/setting_notifier.dart';
import 'package:mulink/ui/home_screen/main_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      themeMode: ref.watch(settingProvider).themeMode,
      theme: FlexThemeData.light(
        useMaterial3: true,
        scheme: FlexScheme.indigoM3,
      ),
      darkTheme: FlexThemeData.dark(
        useMaterial3: true,
        scheme: FlexScheme.indigoM3,
      ),
      home: const MainScreen(),
    );
  }
}
