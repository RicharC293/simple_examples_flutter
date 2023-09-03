import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TikTokAnimationScreen extends StatefulWidget {
  const TikTokAnimationScreen({super.key});

  @override
  State<TikTokAnimationScreen> createState() => _TikTokAnimationScreenState();
}

class _TikTokAnimationScreenState extends State<TikTokAnimationScreen> {
  late Timer _timer;

  double _pinkPositionV = 0.0;
  double _pinkPositionH = 0.0;
  double _cyanPositionV = 0.0;
  double _cyanPositionH = 0.0;

  final _opacityDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Future.delayed(_opacityDuration);
      _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        _pinkPositionV = _randPosition();
        _pinkPositionH = _randPosition();
        _cyanPositionV = _randPosition();
        _cyanPositionH = _randPosition();
        setState(() {});
      });
    });
  }

  double _randPosition() {
    final random = Random();
    return random.nextInt(10) - 5;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: _opacityDuration,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: child,
        ),
        child: Stack(
          children: [
            Positioned(
              left: _pinkPositionH,
              top: _pinkPositionV,
              child: const _Body(color: Colors.pink),
            ),
            Positioned(
              left: _cyanPositionH,
              top: _cyanPositionV,
              child: const _Body(color: Colors.cyan),
            ),
            const _Body(),
          ],
        ),
      )),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({this.color = Colors.white});

  final Color color;

  final symbol = '''
          ⠀⠀⠀⠀⠀⠀⠀⠀⣶⣶⣶⡀⠀⠀
          ⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣷⣄⣀
          ⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿
          ⠀⠀⢀⣠⣴⣶⣶⠀⣿⣿⣿⠉⠉⠉
          ⠀⣴⣿⣿⣿⣿⣿⠀⣿⣿⣿⠀⠀⠀
          ⢸⣿⣿⡿⠉⠀⠈⠀⣿⣿⣿⠀⠀⠀
          ⢹⣿⣿⣷⡀⠀⠀⣰⣿⣿⣿⠀⠀⠀
          ⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀
          ⠀⠀⠙⠻⠿⠿⠿⠿⠋⠁⠀⠀⠀⠀
        ''';

  final text = "TikTok";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          symbol,
          style: TextStyle(fontSize: 20, color: color),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
