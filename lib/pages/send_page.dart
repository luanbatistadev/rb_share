import 'dart:async';

import 'package:collection/collection.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/provider/device_info_provider.dart';
import 'package:rb_share/provider/favorites_provider.dart';
import 'package:rb_share/provider/network/send_provider.dart';
import 'package:rb_share/theme.dart';
import 'package:rb_share/util/native/taskbar_helper.dart';
import 'package:rb_share/widget/animations/initial_fade_transition.dart';
import 'package:rb_share/widget/animations/initial_slide_transition.dart';
import 'package:rb_share/widget/dialogs/error_dialog.dart';
import 'package:rb_share/widget/list_tile/device_list_tile.dart';
import 'package:rb_share/widget/responsive_list_view.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';
import 'package:windows_taskbar/windows_taskbar.dart';

class SendPage extends StatefulWidget {
  final bool showAppBar;
  final bool closeSessionOnClose;
  final String sessionId;

  const SendPage({
    super.key,
    required this.showAppBar,
    required this.closeSessionOnClose,
    required this.sessionId,
  });

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> with Refena {
  Device? _myDevice;
  Device? _targetDevice;

  @override
  void dispose() {
    super.dispose();
    unawaited(TaskbarHelper.clearProgressBar());
  }

  void _cancel() {
    // the state will be lost so we store them temporarily (only for UI)
    final myDevice = ref.read(deviceFullInfoProvider);
    final sendState = ref.read(sendProvider)[widget.sessionId];
    if (sendState == null) {
      return;
    }

    setState(() {
      _myDevice = myDevice;
      _targetDevice = sendState.target;
    });
    ref.notifier(sendProvider).cancelSession(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendProvider)[widget.sessionId];
    if (sendState == null && _myDevice == null && _targetDevice == null) {
      return Scaffold(
        body: Container(),
      );
    }
    final myDevice = ref.watch(deviceFullInfoProvider);
    final targetDevice = sendState?.target ?? _targetDevice!;
    final targetFavoriteEntry = ref
        .watch(favoritesProvider)
        .firstWhereOrNull((e) => e.fingerprint == targetDevice.fingerprint);
    final waiting = sendState?.status == SessionStatus.waiting;

    if (sendState?.status == SessionStatus.declined ||
        sendState?.status == SessionStatus.finishedWithErrors) {
      unawaited(TaskbarHelper.setProgressBarMode(TaskbarProgressMode.error));
    } else {
      unawaited(TaskbarHelper.setProgressBarMode(TaskbarProgressMode.indeterminate));
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (value) {
        if (widget.closeSessionOnClose) {
          _cancel();
        }
      },
      child: Scaffold(
        appBar: widget.showAppBar ? AppBar() : null,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: ResponsiveListView.defaultMaxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          InitialSlideTransition(
                            origin: const Offset(0, -1),
                            duration: const Duration(milliseconds: 400),
                            child: DeviceListTile(
                              device: myDevice,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const InitialFadeTransition(
                            duration: Duration(milliseconds: 300),
                            delay: Duration(milliseconds: 400),
                            child: Icon(Icons.arrow_downward),
                          ),
                          const SizedBox(height: 20),
                          Hero(
                            tag: 'device-${targetDevice.ip}',
                            child: DeviceListTile(
                              device: targetDevice,
                              nameOverride: targetFavoriteEntry?.alias,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (sendState != null)
                      InitialFadeTransition(
                        duration: const Duration(milliseconds: 300),
                        delay: const Duration(milliseconds: 400),
                        child: Column(
                          children: [
                            if (sendState.status == SessionStatus.waiting)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(t.sendPage.waiting, textAlign: TextAlign.center),
                              )
                            else if (sendState.status == SessionStatus.declined)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  t.sendPage.rejected,
                                  style: TextStyle(color: Theme.of(context).colorScheme.warning),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else if (sendState.status == SessionStatus.recipientBusy)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  t.sendPage.busy,
                                  style: TextStyle(color: Theme.of(context).colorScheme.warning),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else if (sendState.status == SessionStatus.finishedWithErrors)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      t.general.error,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.warning,
                                      ),
                                    ),
                                    if (sendState.errorMessage != null)
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Theme.of(context).colorScheme.warning,
                                        ),
                                        onPressed: () async => showDialog(
                                          context: context,
                                          builder: (_) =>
                                              ErrorDialog(error: sendState.errorMessage!),
                                        ),
                                        child: const Icon(Icons.info),
                                      ),
                                  ],
                                ),
                              ),
                            Center(
                              child: FilledButton.icon(
                                onPressed: () {
                                  _cancel();
                                  context.pop();
                                },
                                icon: Icon(waiting ? Icons.close : Icons.check_circle),
                                label: Text(waiting ? t.general.cancel : t.general.close),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
