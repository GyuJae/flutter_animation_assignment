import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  static const int boxCount = 25;

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animations'),
      ),
      body: Center(
        child: GridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(
            boxCount,
            (index) {
              return ShiningBox(
                index: index,
                animationController: _animationController,
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShiningBox extends StatefulWidget {
  const ShiningBox({
    super.key,
    required this.index,
    required this.animationController,
  });

  final int index;
  final AnimationController animationController;

  @override
  State<ShiningBox> createState() => _ShiningBoxState();
}

class _ShiningBoxState extends State<ShiningBox> {
  late final Animation<double> _animation = TweenSequence([
    TweenSequenceItem(
      tween: Tween<double>(begin: 1.0, end: 0.3),
      weight: _ExplicitAnimationsScreenState.boxCount.toDouble(),
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 0.3, end: 1.0),
      weight: _ExplicitAnimationsScreenState.boxCount.toDouble(),
    ),
  ]).animate(
    CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        widget.index / _ExplicitAnimationsScreenState.boxCount,
        (widget.index + 1) / _ExplicitAnimationsScreenState.boxCount,
        curve: Curves.easeInOut,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10 * _animation.value),
            ),
          ),
        );
      },
    );
  }
}
