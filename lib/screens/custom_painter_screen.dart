import 'dart:math';

import 'package:flutter/material.dart';

class CustomPainterScreen extends StatefulWidget {
  const CustomPainterScreen({super.key});

  @override
  State<CustomPainterScreen> createState() => _CustomPainterScreenState();
}

class _CustomPainterScreenState extends State<CustomPainterScreen>
    with SingleTickerProviderStateMixin {
  static const double _timerSize = 300.0;
  static const SecondTime _secondTime = SecondTime(5);

  late TimerManager _timerManager = TimerManager(
    controller: _controller,
    status: TimerStatus.fromAnimationStatus(_controller.status),
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: _secondTime.defaultSecond),
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _controller.reset();

      setState(
        () {
          _timerManager = TimerManager(
            controller: _controller,
            status: TimerStatus.fromAnimationStatus(status),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Painter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            TimerWidget(
              controller: _controller,
              secondTime: _secondTime,
              size: _timerSize,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _timerManager.reset,
                  child: Container(
                    child: _timerManager.resetIcon(),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _timerManager.playPause,
                  child: _timerManager.playPauseIcon(),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.rectangle,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

enum TimerStatus implements Comparable<TimerStatus> {
  progress(
    animatedStatus: AnimationStatus.forward,
  ),
  stop(
    animatedStatus: AnimationStatus.dismissed,
  );

  const TimerStatus({
    required this.animatedStatus,
  });

  final AnimationStatus animatedStatus;

  @override
  int compareTo(TimerStatus other) {
    return animatedStatus.index.compareTo(other.animatedStatus.index);
  }

  static TimerStatus fromAnimationStatus(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        return TimerStatus.progress;
      case AnimationStatus.dismissed:
        return TimerStatus.stop;
      default:
        return TimerStatus.stop;
    }
  }

  isPlaying() {
    return animatedStatus == TimerStatus.progress.animatedStatus;
  }

  isStopped() {
    return animatedStatus == TimerStatus.stop.animatedStatus;
  }
}

class TimerManager {
  final AnimationController _controller;
  final TimerStatus _status;

  TimerManager({
    required AnimationController controller,
    required TimerStatus status,
  })  : _controller = controller,
        _status = status;

  void playPause() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.forward();
    }
  }

  Widget playPauseIcon() {
    return Container(
      decoration: BoxDecoration(
        color: _status.isPlaying() ? Colors.red : Colors.black12,
        shape: BoxShape.circle,
      ),
      width: 80,
      height: 80,
      child: Icon(
        _controller.isAnimating ? Icons.pause : Icons.play_arrow,
        color: _status.isPlaying() ? Colors.white : Colors.black,
      ),
    );
  }

  void reset() {
    _controller.reset();
  }

  Icon resetIcon() {
    return const Icon(
      Icons.restart_alt,
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    required AnimationController controller,
    required SecondTime secondTime,
    required double size,
  })  : _controller = controller,
        _secondTime = secondTime,
        _size = size;

  final AnimationController _controller;
  final SecondTime _secondTime;
  final double _size;

  static const double secondTimeSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            width: _size,
            height: _size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  _secondTime.displayRemainingMMssByProgress(_controller.value),
                  style: const TextStyle(
                    fontSize: secondTimeSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomPaint(
                  size: Size(_size, _size),
                  painter: TimerPainter(
                    progress: _controller.value,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;

  static const bgArcStrokeWidth = 20.0;

  TimerPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = bgArcStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    final Paint progressPaint = Paint()
      ..color = Colors.red.shade400
      ..strokeWidth = bgArcStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -pi / 2,
      pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant TimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class SecondTime {
  final int _seconds;

  const SecondTime(this._seconds);

  int get defaultSecond => _seconds;

  String _displayMMss(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remain = seconds % 60;
    return '$minutes:${remain.toString().padLeft(2, '0')}';
  }

  String displayRemainingMMssByProgress(double progress) {
    final int overtimeSeconds = (_seconds * progress).floor();
    return _displayMMss(_seconds - overtimeSeconds);
  }
}
