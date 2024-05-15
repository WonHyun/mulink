import 'package:flutter/material.dart';
import 'package:mulink/ui/home_screen/main_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.dark(
        primary: Colors.indigo.shade200,
        secondary: Colors.indigo.shade600,
      )),
      home: const MainScreen(),
    );
  }
}
