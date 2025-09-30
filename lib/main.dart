// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_debouncer_thorttler_rxdart_example/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debounce & Throttle Demo',
      home: const HomePage(),
    );
  }
}
