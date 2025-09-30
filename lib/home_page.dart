import 'package:flutter/material.dart';
import 'package:flutter_debouncer_thorttler_rxdart_example/rxdart_search_page.dart';
import 'debounce_search_page.dart';
import 'throttle_scroll_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debounce & Throttle Demos')),
      body: Center(
        child: SingleChildScrollView(
          // Butonlar sığmazsa kaydırılabilir yapalım
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Senaryo 1: Arama Optimizasyonu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DebounceSearchPage()),
                ),
                child: const Text('Debounce (Manuel Timer)'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RxDartSearchPage()),
                ),
                child: const Text('Debounce (rxdart)'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Senaryo 2: Olay Seyreltme',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ThrottleScrollPage()),
                ),
                child: const Text('Throttle (Kaydırma Optimizasyonu)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
