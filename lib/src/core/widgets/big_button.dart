import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const BigButton({
    super.key,
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const buttonWidth = 90.0;
    const buttonHeight = 65.0;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: buttonWidth,
        minWidth: buttonWidth,
        minHeight: buttonHeight,
        maxHeight: buttonHeight,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.only(left: 2, right: 2, top: 10, bottom: 8),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            FittedBox(
              alignment: Alignment.bottomCenter,
              child: Text(label, maxLines: 1),
            ),
          ],
        ),
      ),
    );
  }
}
