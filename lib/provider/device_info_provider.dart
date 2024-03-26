import 'package:collection/collection.dart';
import 'package:common/common.dart';
import 'package:rb_share/provider/local_ip_provider.dart';
import 'package:rb_share/provider/network/server/server_provider.dart';
import 'package:rb_share/provider/security_provider.dart';
import 'package:rb_share/provider/settings_provider.dart';
import 'package:rb_share/util/native/device_info_helper.dart';
import 'package:refena_flutter/refena_flutter.dart';

final deviceRawInfoProvider = Provider<DeviceInfoResult>((ref) {
  throw Exception('deviceRawInfoProvider not initialized');
});

final deviceInfoProvider = ViewProvider<DeviceInfoResult>((ref) {
  final (deviceType, deviceModel) =
      ref.watch(settingsProvider.select((state) => (state.deviceType, state.deviceModel)));
  final rawInfo = ref.watch(deviceRawInfoProvider);

  return DeviceInfoResult(
    deviceType: deviceType ?? rawInfo.deviceType,
    deviceModel: deviceModel ?? rawInfo.deviceModel,
    androidSdkInt: rawInfo.androidSdkInt,
  );
});

final deviceFullInfoProvider = ViewProvider((ref) {
  final networkInfo = ref.watch(localIpProvider);
  final serverState = ref.watch(serverProvider);
  final rawInfo = ref.watch(deviceInfoProvider);
  final securityContext = ref.read(securityProvider);
  return Device(
    ip: networkInfo.localIps.firstOrNull ?? '-',
    version: protocolVersion,
    port: serverState?.port ?? -1,
    alias: serverState?.alias ?? '-',
    https: serverState?.https ?? true,
    fingerprint: securityContext.certificateHash,
    deviceModel: rawInfo.deviceModel,
    deviceType: rawInfo.deviceType,
    download: serverState?.webSendState != null,
  );
});
