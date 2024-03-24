import 'package:rb_share/src/core/entities/device.dart';

class InfoDto {
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

  factory InfoDto.fromMap(Map<String, dynamic> map) {
    return InfoDto(
      alias: map['alias'],
      version: map['version'],
      deviceModel: map['deviceModel'],
      deviceType: map['deviceType'],
      fingerprint: map['fingerprint'],
      download: map['download'],
    );
  }
}

extension InfoToDeviceExt on InfoDto {
  /// Convert [InfoDto] to [Device].
  /// Since this HTTP request was successful, the [port] and [https] are known.
  Device toDevice(String ip, int port, bool https) {
    return Device(
      ip: ip,
      version: version ?? '1.0',
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