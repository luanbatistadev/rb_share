import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/widget/dialogs/custom_bottom_sheet.dart';
import 'package:routerino/routerino.dart';

class CancelSessionDialog extends StatelessWidget {
  const CancelSessionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: t.dialogs.cancelSession.title,
      description: t.dialogs.cancelSession.content,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(t.general.continueStr),
          ),
          ElevatedButton.icon(
            onPressed: () => context.pop(true),
            icon: const Icon(Icons.close),
            label: Text(t.general.cancel),
          ),
        ],
      ),
    );
  }
}
