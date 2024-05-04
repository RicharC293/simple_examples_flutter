import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_examples/examples/animated_switch/animated_switch_preview.dart';
import 'package:simple_examples/examples/delivery_button/delivery_button.dart';
import 'package:simple_examples/examples/image_slider/image_slider.dart';
import 'package:simple_examples/examples/tik_tok_animation/tik_tok_animation.dart';

import 'examples/apple_maps/apple_maps.dart';
import 'examples/ios_calculator/screens/calculator_screen.dart';

class SimpleExamples extends StatelessWidget {
  const SimpleExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Examples")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          //create a button
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ImageSlider();
              }));
            },
            child: const Text("Image Slider"),
          ),
          if (!kIsWeb && Platform.isIOS) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AppleMapsExample();
                }));
              },
              child: const Text("Apple Maps"),
            ),
          ],
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const DeliveryButton();
              }));
            },
            child: const Text("Delivery button"),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CalculatorScreen();
              }));
            },
            child: const Text("iOS Calculator"),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const TikTokAnimationScreen();
              }));
            },
            child: const Text("TikTok Animation"),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AnimatedSwitchPreview();
              }));
            },
            child: const Text("Animated Switcher"),
          ),
        ],
      ),
    );
  }
}
