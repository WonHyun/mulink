import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'initialize_app.dart';

void main() async {
  await initializeApp();
  runApp(const ProviderScope(child: App()));
}
