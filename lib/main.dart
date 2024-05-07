import 'package:flutter/material.dart';
import 'app.dart';
import 'initialize_app.dart';

void main() async {
  await initializeApp();
  runApp(const App());
}
