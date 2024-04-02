// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/pages/tabs/send_tab_vm.dart';
import 'package:rb_share/provider/animation_provider.dart';
import 'package:rb_share/provider/settings_provider.dart';
import 'package:rb_share/util/native/platform_check.dart';
import 'package:rb_share/widget/opacity_slideshow.dart';
import 'package:rb_share/widget/responsive_list_view.dart';
import 'package:refena_flutter/refena_flutter.dart';

import '../../../model/send_mode.dart';

class SendModes extends StatefulWidget {
  const SendModes({
    super.key,
    required this.goToNextPage,
    required this.goToPreviosPage,
  });
  final VoidCallback goToNextPage;
  final VoidCallback goToPreviosPage;

  @override
  State<SendModes> createState() => _SendModesState();
}

const _horizontalPadding = 15.0;

class _SendModesState extends State<SendModes> {
  @override
  Widget build(BuildContext context) {
    final badgeColor = Theme.of(context).colorScheme.secondaryContainer;
    return ViewModelBuilder(
      provider: sendTabVmProvider,
      builder: (context, vm) {
        return Scaffold(
          floatingActionButton: vm.selectedFiles.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        onPressed: widget.goToPreviosPage,
                        backgroundColor: badgeColor,
                        child: const Icon(Icons.arrow_back_rounded),
                      ),
                      FloatingActionButton(
                        onPressed: widget.goToNextPage,
                        backgroundColor: badgeColor,
                        child: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: ResponsiveListView(
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
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                    child: Consumer(
                      builder: (context, ref) {
                        final animations = ref.watch(animationProvider);
                        return OpacitySlideshow(
                          durationMillis: 6000,
                          running: animations,
                          children: [
                            Text(
                              t.sendTab.help,
                              style: const TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            if (checkPlatformCanReceiveShareIntent())
                              Text(
                                t.sendTab.shareIntentInfo,
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
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
