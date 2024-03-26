import 'package:common/src/constants.dart';
import 'package:common/src/model/device.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'info_dto.mapper.dart';

@MappableClass()
class InfoDto with InfoDtoMappable {
  final String alias;
  final String? version; // v2, format: major.minor
  final String? deviceModel;
  final DeviceType? deviceType;
  final String? fingerprint; // v2
  final bool? download; // v2

  const InfoDto({
    required this.alias,
    required this.version,
    required this.deviceModel,
    required this.deviceType,
    required this.fingerprint,
    required this.download,
  });

  static const fromJson = InfoDtoMapper.fromJson;
}

extension InfoToDeviceExt on InfoDto {
  /// Convert [InfoDto] to [Device].
  /// Since this HTTP request was successful, the [port] and [https] are known.
  Device toDevice(String ip, int port, bool https) {
    return Device(
      ip: ip,
      version: version ?? fallbackProtocolVersion,
      port: port,
      https: https,
      fingerprint: fingerprint ?? '',
      alias: alias,
      deviceModel: deviceModel,
      deviceType: deviceType ?? DeviceType.desktop,
      download: download ?? false,
    );
  }
}
