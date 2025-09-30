import 'package:flutter/material.dart';
import '../utils/throttler.dart';

class ThrottleScrollPage extends StatefulWidget {
  const ThrottleScrollPage({Key? key}) : super(key: key);
  @override
  State<ThrottleScrollPage> createState() => _ThrottleScrollPageState();
}

class _ThrottleScrollPageState extends State<ThrottleScrollPage> {
  final _scrollController = ScrollController();
  // 300ms'de bir tetiklenecek Throttler.
  final _throttler = Throttler(milliseconds: 300);
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // _onScroll metodu saniyede onlarca kez tetiklenir.
    // Ancak Throttler, içindeki mantığın sadece 300ms'de bir çalışmasını sağlar.
    _throttler.run(() {
      final currentPosition = _scrollController.position.pixels;
      print('THROTTLED: Checking scroll position: $currentPosition');

      // Butonu sadece belirli bir scroll miktarından sonra göster.
      if (currentPosition > 400) {
        if (!_showScrollToTopButton) {
          setState(() => _showScrollToTopButton = true);
        }
      } else {
        if (_showScrollToTopButton) {
          setState(() => _showScrollToTopButton = false);
        }
      }
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _throttler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Throttle Kaydırma')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 100,
        itemBuilder: (context, index) =>
            ListTile(title: Text('Eleman #$index')),
      ),
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}
