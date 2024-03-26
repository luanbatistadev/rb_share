import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rb_share/util/ui/snackbar.dart';

class CopyableText extends StatelessWidget {
  final TextSpan? prefix;
  final String name;
  final String? value;

  const CopyableText({super.key, 
    this.prefix,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: value == null
          ? null
          : () async {
              await Clipboard.setData(ClipboardData(text: value!));
              if (context.mounted) {
                context.showSnackBar('Copied $name to clipboard!');
              }
            },
      child: Text.rich(
        TextSpan(
          children: [
            if (prefix != null) prefix!,
            TextSpan(text: value ?? '-'),
          ],
        ),
      ),
    );
  }
}
