import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:mulink/ui/home_screen/main_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
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
