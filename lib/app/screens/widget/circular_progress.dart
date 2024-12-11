import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Lottie.asset(
          'assets/lottie/processing_circle.json'),
    );
  }
}
