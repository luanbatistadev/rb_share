import 'package:flutter/material.dart';

class RBShareLogo extends StatelessWidget {
  final bool withText;

  const RBShareLogo({super.key, required this.withText});

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/logo.png',
      height: 200,
      width: 200,
    );

    if (withText) {
      return Column(
        children: [
          logo,
          const Text(
            'RB Share',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return logo;
    }
  }
}
