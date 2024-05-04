import 'package:flutter/material.dart';
import 'package:simple_examples/examples/animated_switch/widgets/base_switch.dart';

class AnimatedSwitchPreview extends StatelessWidget {
  const AnimatedSwitchPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animated Switch")),
      body: const Center(
        child: AnimatedSwitch(),
      ),
    );
  }
}
