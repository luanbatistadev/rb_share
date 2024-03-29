import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/model/send_mode.dart';
import 'package:rb_share/pages/tabs/send_tab.dart';
import 'package:rb_share/pages/tabs/send_tab_vm.dart';
import 'package:rb_share/provider/animation_provider.dart';
import 'package:rb_share/util/native/file_picker.dart';
import 'package:rb_share/util/native/platform_check.dart';
import 'package:rb_share/widget/list_tile/device_list_tile.dart';
import 'package:rb_share/widget/list_tile/device_placeholder_list_tile.dart';
import 'package:rb_share/widget/opacity_slideshow.dart';
import 'package:rb_share/widget/responsive_list_view.dart';
import 'package:refena_flutter/refena_flutter.dart';

import '../../../widget/custom_icon_button.dart';

const _horizontalPadding = 15.0;
final _options = FilePickerOption.getOptionsForPlatform();

class NearbyDevices extends StatefulWidget {
  final VoidCallback callback;

  const NearbyDevices({super.key, required this.callback});

  @override
  State<NearbyDevices> createState() => _NearbyDevicesState();
}

class _NearbyDevicesState extends State<NearbyDevices> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      provider: sendTabVmProvider,
      builder: (context, vm) {
        final ref = context.ref;
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
                          ips: vm.localIps,
                        ),
                        Tooltip(
                          message: t.dialogs.addressInput.title,
                          child: CustomIconButton(
                            onPressed: () async => vm.onTapAddress(context),
                            child: const Icon(Icons.ads_click),
                          ),
                        ),
                        Tooltip(
                          message: t.dialogs.favoriteDialog.title,
                          child: CustomIconButton(
                            onPressed: () async => await vm.onTapFavorite(context),
                            child: const Icon(Icons.favorite),
                          ),
                        ),
                      ],
                    ),
                    if (vm.nearbyDevices.isEmpty)
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
                    ...vm.nearbyDevices.map((device) {
                      final favoriteEntry = vm.favoriteDevices
                          .firstWhereOrNull((e) => e.fingerprint == device.fingerprint);
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: _horizontalPadding,
                          right: _horizontalPadding,
                        ),
                        child: Hero(
                          tag: 'device-${device.ip}',
                          child: vm.sendMode == SendMode.multiple
                              ? MultiSendDeviceListTile(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
