import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/model/send_mode.dart';
import 'package:rb_share/pages/tabs/send_tab.dart';
import 'package:rb_share/pages/tabs/send_tab_vm.dart';
import 'package:rb_share/provider/animation_provider.dart';
import 'package:rb_share/util/native/platform_check.dart';
import 'package:rb_share/widget/list_tile/device_list_tile.dart';
import 'package:rb_share/widget/list_tile/device_placeholder_list_tile.dart';
import 'package:rb_share/widget/opacity_slideshow.dart';
import 'package:rb_share/widget/responsive_list_view.dart';
import 'package:refena_flutter/refena_flutter.dart';

import '../../../widget/custom_icon_button.dart';

const _horizontalPadding = 15.0;

class NearbyDevices extends StatefulWidget {
  final VoidCallback callback;
  final SendTabVm vm;

  const NearbyDevices({
    super.key,
    required this.callback,
    required this.vm,
  });

  @override
  State<NearbyDevices> createState() => _NearbyDevicesState();
}

class _NearbyDevicesState extends State<NearbyDevices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ResponsiveListView(
          padding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                const SizedBox(width: _horizontalPadding),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      t.sendTab.nearbyDevices,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ScanButton(
                  ips: widget.vm.localIps,
                ),
                Tooltip(
                  message: t.dialogs.addressInput.title,
                  child: CustomIconButton(
                    onPressed: () async => widget.vm.onTapAddress(context),
                    child: const Icon(Icons.list_rounded),
                  ),
                ),
                Tooltip(
                  message: t.dialogs.favoriteDialog.title,
                  child: CustomIconButton(
                    onPressed: () async => await widget.vm.onTapFavorite(context),
                    child: const Icon(Icons.favorite),
                  ),
                ),
              ],
            ),
            if (widget.vm.nearbyDevices.isEmpty)
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 10,
                  left: _horizontalPadding,
                  right: _horizontalPadding,
                ),
                child: Opacity(
                  opacity: 0.3,
                  child: DevicePlaceholderListTile(),
                ),
              ),
            ...widget.vm.nearbyDevices.map((device) {
              final favoriteEntry = widget.vm.favoriteDevices
                  .firstWhereOrNull((e) => e.fingerprint == device.fingerprint);
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: _horizontalPadding,
                  right: _horizontalPadding,
                ),
                child: Hero(
                  tag: 'device-${device.ip}',
                  child: widget.vm.sendMode == SendMode.multiple
                      ? MultiSendDeviceListTile(
                          device: device,
                          isFavorite: favoriteEntry != null,
                          nameOverride: favoriteEntry?.alias,
                          vm: widget.vm,
                        )
                      : DeviceListTile(
                          device: device,
                          isFavorite: favoriteEntry != null,
                          nameOverride: favoriteEntry?.alias,
                          onFavoriteTap: () async => await widget.vm.onToggleFavorite(device),
                          onTap: () async => await widget.vm.onTapDevice(context, device),
                        ),
                ),
              );
            }),
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
