// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/pages/tabs/send_tab_vm.dart';
import 'package:rb_share/provider/settings_provider.dart';
import 'package:rb_share/widget/responsive_list_view.dart';
import 'package:refena_flutter/refena_flutter.dart';

import '../../../model/send_mode.dart';

class SendModes extends StatefulWidget {
  const SendModes({
    super.key,
    required this.callback,
  });
  final VoidCallback callback;

  @override
  State<SendModes> createState() => _SendModesState();
}

class _SendModesState extends State<SendModes> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      provider: sendTabVmProvider,
      builder: (context, vm) {
        return Scaffold(
          floatingActionButton: vm.selectedFiles.isEmpty
              ? null
              : FloatingActionButton(
                  onPressed: widget.callback,
                  child: const Icon(Icons.send),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ResponsiveListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      t.dialogs.sendModeHelp.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SendModeItem(
                          mode: t.sendTab.sendModes.single,
                          sendMode: SendMode.single,
                          explanation: t.dialogs.sendModeHelp.single,
                          callback: () => vm.onTapSendMode(context, SendMode.single),
                        ),
                        const SizedBox(height: 10),
                        _SendModeItem(
                          mode: t.sendTab.sendModes.multiple,
                          sendMode: SendMode.multiple,
                          explanation: t.dialogs.sendModeHelp.multiple,
                          callback: () => vm.onTapSendMode(context, SendMode.multiple),
                        ),
                        const SizedBox(height: 10),
                        _SendModeItem(
                          mode: t.sendTab.sendModes.link,
                          sendMode: SendMode.link,
                          explanation: t.dialogs.sendModeHelp.link,
                          callback: () => vm.onTapSendMode(context, SendMode.link),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SendModeItem extends StatelessWidget {
  final String mode;
  final String explanation;
  final SendMode sendMode;
  final VoidCallback callback;
  const _SendModeItem({
    required this.mode,
    required this.explanation,
    required this.sendMode,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Row(
        children: [
          Consumer(
            builder: (context, ref) {
              final sendMo = ref.watch(settingsProvider.select((s) => s.sendMode));
              return AnimatedScale(
                scale: sendMode == sendMo ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutBack,
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 40,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mode, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(explanation),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
