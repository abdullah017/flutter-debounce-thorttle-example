import 'dart:async';
import 'package:flutter/foundation.dart';

class Throttler {
  final int milliseconds;
  Timer? _timer;
  bool _isReady = true;

  Throttler({required this.milliseconds});

  void run(VoidCallback action) {
    if (_isReady) {
      action();
      _isReady = false;
      _timer = Timer(Duration(milliseconds: milliseconds), () {
        _isReady = true;
      });
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
