import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rb_share/src/core/widgets/big_button.dart';
import 'package:rb_share/src/core/widgets/rotating_widget.dart';

const _horizontalPadding = 15.0;
final _options = FilePickerOption.getOptionsForPlatform();

class SendTab extends StatelessWidget {
  const SendTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 20),
            if (false) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Text(
                  'Seleçao',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    ..._options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: BigButton(
                          icon: option.icon,
                          label: option.label,
                          filled: false,
                          onTap: () async {},
                        ),
                      );
                    }),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ] else ...[
              Card(
                margin: const EdgeInsets.only(bottom: 10, left: _horizontalPadding, right: _horizontalPadding),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        't.sendTab.selection.title',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('t.sendTab.selection.files(files: vm.selectedFiles.length)'),
                      Text('t.sendTab.selection.size(size: vm.selectedFiles.fold(0, (prev, curr) => prev + curr.size).asReadableFileSize)'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            final file = vm.selectedFiles[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SmartFileThumbnail.fromCrossFile(file),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.onSurface,
                            ),
                            onPressed: () async {
                              // await context.push(() => const SelectedFilesPage());
                            },
                            child: Text('t.general.edit'),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: () async {
                              // await AddFileDialog.open(
                              //   context: context,
                              //   options: _options,
                              // );
                            },
                            icon: const Icon(Icons.add),
                            label: Text('t.general.add'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Row(
              children: [
                const SizedBox(width: _horizontalPadding),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('t.sendTab.nearbyDevices', style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
                const SizedBox(width: 10),
                _ScanButton(
                  ips: ['vm.localIps'],
                ),
                Tooltip(
                  message: 't.dialogs.addressInput.title',
                  child: CustomIconButton(
                    onPressed: () async {},
                    child: const Icon(Icons.ads_click),
                  ),
                ),
                Tooltip(
                  message: 't.dialogs.favoriteDialog.title',
                  child: CustomIconButton(
                    onPressed: () {},
                    child: const Icon(Icons.favorite),
                  ),
                ),
                _SendModeButton(
                  onSelect: (mode) async {},
                ),
              ],
            ),
            if (true)
              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: _horizontalPadding, right: _horizontalPadding),
                child: Opacity(
                  opacity: 0.3,
                  child: DevicePlaceholderListTile(),
                ),
              ),
            ...vm.nearbyDevices.map((device) {
              final favoriteEntry = vm.favoriteDevices.firstWhereOrNull((e) => e.fingerprint == device.fingerprint);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, left: _horizontalPadding, right: _horizontalPadding),
                child: Hero(
                  tag: 'device-${device.ip}',
                  child: vm.sendMode == SendMode.multiple
                      ? _MultiSendDeviceListTile(
                          device: device,
                          isFavorite: favoriteEntry != null,
                          nameOverride: favoriteEntry?.alias,
                          vm: vm,
                        )
                      : DeviceListTile(
                          device: device,
                          isFavorite: favoriteEntry != null,
                          nameOverride: favoriteEntry?.alias,
                          onFavoriteTap: () async => await vm.onToggleFavorite(device),
                          onTap: () async => await vm.onTapDevice(context, device),
                        ),
                ),
              );
            }),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () async {
                  await context.push(() => const TroubleshootPage());
                },
                child: Text('t.troubleshootPage.title'),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Consumer(
                builder: (context, ref) {
                  final animations = ref.watch(animationProvider);
                  return OpacitySlideshow(
                    durationMillis: 6000,
                    running: animations,
                    children: [
                      Text('t.sendTab.help', style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                      if (true)
                        Text('t.sendTab.shareIntentInfo', style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        );
      },
    );
}

/// A button that opens a popup menu to select [T].
/// This is used for the scan button and the send mode button.
class _CircularPopupButton<T> extends StatelessWidget {
  final String tooltip;
  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final Widget child;

  const _CircularPopupButton({
    required this.tooltip,
    required this.onSelected,
    required this.itemBuilder,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: Material(
        type: MaterialType.transparency,
        child: DividerTheme(
          data: DividerThemeData(
            color: Theme.of(context).brightness == Brightness.light ? Colors.teal.shade100 : Colors.grey.shade700,
          ),
          child: PopupMenuButton(
            offset: const Offset(0, 40),
            onSelected: onSelected,
            tooltip: tooltip,
            itemBuilder: itemBuilder,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The scan button that uses [_CircularPopupButton].
class _ScanButton extends StatelessWidget {
  final List<String> ips;

  const _ScanButton({
    required this.ips,
  });

  @override
  Widget build(BuildContext context) {
    final (scanningFavorites, scanningIps) = context.ref.watch(nearbyDevicesProvider.select((s) => (s.runningFavoriteScan, s.runningIps)));
    final animations = context.ref.watch(animationProvider);

    final spinning = (scanningFavorites || scanningIps.isNotEmpty) && animations;
    final iconColor = !animations && scanningIps.isNotEmpty ? Theme.of(context).colorScheme.warning : null;

    if (ips.length <= StartSmartScan.maxInterfaces) {
      return RotatingWidget(
        duration: const Duration(seconds: 2),
        spinning: spinning,
        reverse: true,
        child: CustomIconButton(
          onPressed: () async {
            context.redux(nearbyDevicesProvider).dispatch(ClearFoundDevicesAction());
            await context.ref.dispatchAsync(StartSmartScan(forceLegacy: true));
          },
          child: Icon(Icons.sync, color: iconColor),
        ),
      );
    }

    return _CircularPopupButton(
      tooltip: 't.sendTab.scan',
      onSelected: (ip) async {
        // context.redux(nearbyDevicesProvider).dispatch(ClearFoundDevicesAction());
        // await context.ref.dispatchAsync(StartLegacySubnetScan(subnets: [ip]));
      },
      itemBuilder: (_) {
        return [
          ...ips.map(
            (ip) => PopupMenuItem(
              value: ip,
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RotatingSyncIcon(ip),
                  const SizedBox(width: 10),
                  Text(ip),
                ],
              ),
            ),
          ),
        ];
      },
      child: RotatingWidget(
        duration: const Duration(seconds: 2),
        spinning: spinning,
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.sync, color: iconColor),
        ),
      ),
    );
  }
}

/// A separate widget, so it gets the latest data from provider.
class _RotatingSyncIcon extends StatelessWidget {
  final String ip;

  const _RotatingSyncIcon(this.ip);

  @override
  Widget build(BuildContext context) {
    return RotatingWidget(
      duration: const Duration(seconds: 2),
      spinning: true,
      reverse: true,
      child: const Icon(Icons.sync),
    );
  }
}

class _SendModeButton extends StatelessWidget {
  final void Function(SendMode mode) onSelect;

  const _SendModeButton({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return _CircularPopupButton<int>(
      tooltip: 't.sendTab.sendMode',
      onSelected: (mode) async {
        switch (mode) {
          case 0:
            onSelect(SendMode.single);
            break;
          case 1:
            onSelect(SendMode.multiple);
            break;
          case 2:
            onSelect(SendMode.link);
            break;
          case -1:
            await showDialog(context: context, builder: (_) => const SendModeHelpDialog());
            break;
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, ref) {
                  final sendMode = ref.watch(settingsProvider.select((s) => s.sendMode));
                  return Visibility(
                    visible: sendMode == SendMode.single,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: const Icon(Icons.check_circle),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(t.sendTab.sendModes.single),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, ref) {
                  final sendMode = ref.watch(settingsProvider.select((s) => s.sendMode));
                  return Visibility(
                    visible: sendMode == SendMode.multiple,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: const Icon(Icons.check_circle),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(t.sendTab.sendModes.multiple),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Icon(Icons.check_circle),
              ),
              const SizedBox(width: 10),
              Text(t.sendTab.sendModes.link),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: -1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help),
              const SizedBox(width: 10),
              Text(t.sendTab.sendModeHelp),
            ],
          ),
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.settings),
      ),
    );
  }
}

/// An advanced list tile which shows the progress of the file transfer.
class _MultiSendDeviceListTile extends StatelessWidget {
  final Device device;
  final bool isFavorite;
  final String? nameOverride;
  final SendTabVm vm;

  const _MultiSendDeviceListTile({
    required this.device,
    required this.isFavorite,
    required this.nameOverride,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    final ref = context.ref;
    final session = ref.watch(sendProvider).values.firstWhereOrNull((s) => s.target.ip == device.ip);
    final double? progress;
    if (session != null) {
      final files = session.files.values.where((f) => f.token != null);
      final progressNotifier = ref.watch(progressProvider);
      final currBytes = files.fold<int>(
          0, (prev, curr) => prev + ((progressNotifier.getProgress(sessionId: session.sessionId, fileId: curr.file.id) * curr.file.size).round()));
      final totalBytes = files.fold<int>(0, (prev, curr) => prev + curr.file.size);
      progress = totalBytes == 0 ? 0 : currBytes / totalBytes;
    } else {
      progress = null;
    }
    return DeviceListTile(
      device: device,
      info: session?.status.humanString,
      progress: progress,
      isFavorite: isFavorite,
      nameOverride: nameOverride,
      onFavoriteTap: () async => await vm.onToggleFavorite(device),
      onTap: () async => await vm.onTapDeviceMultiSend(context, device),
    );
  }
}

extension on SessionStatus {
  String? get humanString {
    switch (this) {
      case SessionStatus.waiting:
        return t.sendPage.waiting;
      case SessionStatus.recipientBusy:
        return t.sendPage.busy;
      case SessionStatus.declined:
        return t.sendPage.rejected;
      case SessionStatus.sending:
        return null;
      case SessionStatus.finished:
        return t.general.finished;
      case SessionStatus.finishedWithErrors:
        return t.progressPage.total.title.finishedError;
      case SessionStatus.canceledBySender:
        return t.progressPage.total.title.canceledSender;
      case SessionStatus.canceledByReceiver:
        return t.progressPage.total.title.canceledReceiver;
    }
  }
}
