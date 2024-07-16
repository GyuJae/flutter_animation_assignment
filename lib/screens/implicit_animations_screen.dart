import 'package:flutter/material.dart';

enum AnimationStatus implements Comparable<AnimationStatus> {
  first(
    value: "first",
    containerColor: Colors.red,
    bgColor: Colors.yellow,
    borderRadius: 0,
    alignment: Alignment.centerLeft,
  ),
  second(
    value: "second",
    containerColor: Colors.blue,
    bgColor: Colors.green,
    borderRadius: 100,
    alignment: Alignment.centerRight,
  );

  const AnimationStatus({
    required this.value,
    required this.containerColor,
    required this.bgColor,
    required this.borderRadius,
    required this.alignment,
  });

  final String value;
  final Color containerColor;
  final Color bgColor;
  final double borderRadius;
  final Alignment alignment;

  @override
  int compareTo(AnimationStatus other) {
    return containerColor.value - other.containerColor.value;
  }
}

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  AnimationStatus _animationStatus = AnimationStatus.first;

  void _toggleAnimation() {
    setState(() {
      if (_animationStatus == AnimationStatus.first) {
        _animationStatus = AnimationStatus.second;
      } else {
        _animationStatus = AnimationStatus.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Implicit Animations"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: _animationStatus.bgColor,
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _animationStatus.containerColor,
                  borderRadius: BorderRadius.circular(
                    _animationStatus.borderRadius,
                  ),
                ),
                onEnd: _toggleAnimation,
              ),
              AnimatedAlign(
                duration: const Duration(seconds: 1),
                alignment: _animationStatus.alignment,
                child: Container(
                  width: 20,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _toggleAnimation,
            child: const Text("Start Animation"),
          )
        ],
      ),
    );
  }
}
