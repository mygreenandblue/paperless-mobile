import 'dart:async';

import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final int start;
  final VoidCallback onCountdownComplete;

  CountdownWidget({required this.start, required this.onCountdownComplete});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late int _countdown;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _countdown = widget.start;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        widget.onCountdownComplete();
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('${_countdown}s');
  }
}
