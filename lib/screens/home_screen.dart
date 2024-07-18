import 'package:animation_assignment_app/screens/explicit_animations_screen.dart';
import 'package:animation_assignment_app/screens/implicit_animations_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Animation Assignment'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImplicitAnimationsScreen(),
                    ),
                  );
                },
                child: const Text("Implicit Animations"),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExplicitAnimationsScreen(),
                    ),
                  );
                },
                child: const Text("Explicit Animations"),
              ),
            )
          ],
        ));
  }
}
