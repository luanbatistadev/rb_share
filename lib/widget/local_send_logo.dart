import 'package:flutter/material.dart';
import 'package:rb_share/gen/assets.gen.dart';

class RBShareLogo extends StatelessWidget {
  final bool withText;

  const RBShareLogo({super.key, required this.withText});

  @override
  Widget build(BuildContext context) {
    final logo = ColorFiltered(
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.primary,
        BlendMode.srcATop,
      ),
      child: Assets.img.logo512.image(
        width: 200,
        height: 200,
      ),
    );

    if (withText) {
      return Column(
        children: [
          logo,
          const Text(
            'RBShare',
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
