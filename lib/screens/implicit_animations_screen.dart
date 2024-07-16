import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatelessWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Implicit Animations"),
      ),
      body: const Center(
        child: Text("Hello Worldf"),
      ),
    );
  }
}
