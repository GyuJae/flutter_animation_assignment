import 'dart:math';

import 'package:flutter/material.dart';

class GestureAnimationScreen extends StatefulWidget {
  const GestureAnimationScreen({super.key});

  @override
  State<GestureAnimationScreen> createState() => _GestureAnimationScreenState();
}

class _GestureAnimationScreenState extends State<GestureAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    lowerBound: size.width * -1,
    upperBound: size.width,
    value: 0.0,
  );

  late final _rotation = RotationTween(
    begin: -15,
    end: 15,
  );

  late final _scale = ScaleTween(
    begin: 0.8,
    end: 1.0,
  );

  CardState cardState = CardState.inProgress;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _animationController.value += details.primaryDelta!;
    setState(() {
      cardState = CardState.positionOf(_animationController.value);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _animationController.animateTo(0);
    setState(() {
      cardState = CardState.inProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gesture Animation")),
      backgroundColor: cardState.color,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: _scale.toScale(
                      position: _animationController.value,
                      width: size.width,
                    ),
                    child: Card(
                      size: size,
                      question: Question(answer: "2", question: "1 + 1 = ?"),
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: Transform.translate(
                      offset: Offset(_animationController.value, 0),
                      child: Transform.rotate(
                        angle: _rotation.toAngle(
                          position: _animationController.value,
                          width: size.width,
                        ),
                        child: Card(
                          size: size,
                          question: Question(
                            answer: "2",
                            question: "1 + 1 = ?",
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class Card extends StatefulWidget {
  final Size size;
  final Question question;

  const Card({
    super.key,
    required this.size,
    required this.question,
  });

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  bool _flip = false;

  void _onTap() {
    if (_flip) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _flip = !_flip;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double angle = _animationController.value * 3.1415926535897932;
        if (_animationController.value >= 0.5) {
          angle = (1.0 - _animationController.value) * 3.1415926535897932;
        }
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          origin: Offset(widget.size.width / 2, 200),
          child: GestureDetector(
            onTap: _onTap,
            child: Container(
              width: widget.size.width * 0.8,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _flip ? widget.question.answer : widget.question.question,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum CardState implements Comparable<CardState> {
  toReview(message: "Need to review", color: Colors.redAccent),
  inProgress(message: "In progress", color: Colors.blueAccent),
  understood(message: "I got it right", color: Colors.greenAccent);

  final String message;
  final Color color;

  const CardState({
    required this.message,
    required this.color,
  });

  @override
  int compareTo(CardState other) => index.compareTo(other.index);

  static CardState positionOf(double value) {
    if (value > 0) {
      return CardState.understood;
    } else if (value < 0) {
      return CardState.toReview;
    } else {
      return CardState.inProgress;
    }
  }
}

class RotationTween extends Tween<double> {
  RotationTween({required double begin, required double end})
      : super(
          begin: begin,
          end: end,
        );

  toAngle({
    required double position,
    required double width,
  }) {
    return transform((position + width / 2) / width) * pi / 180;
  }
}

class ScaleTween extends Tween<double> {
  ScaleTween({required double begin, required double end})
      : super(
          begin: begin,
          end: end,
        );

  toScale({
    required double position,
    required double width,
  }) {
    return transform(position.abs() / width);
  }
}

class Question {
  final String question;
  final String answer;

  Question({
    required this.question,
    required this.answer,
  });
}
