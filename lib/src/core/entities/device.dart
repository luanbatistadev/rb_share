// import 'package:dart_mappable/dart_mappable.dart';

// part 'device.mapper.dart';

import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  desktop,
  web,
  headless,
  server,
}

extension DeviceTypeExt on DeviceType {
  IconData get icon {
    return switch (this) {
      DeviceType.mobile => Icons.smartphone,
      DeviceType.desktop => Icons.computer,
      DeviceType.web => Icons.language,
      DeviceType.headless => Icons.terminal,
      DeviceType.server => Icons.dns,
    };
  }
}


// /// Internal device model.
// /// It gets not serialized.
// @MappableClass()
class Device {
  final String ip;
  final String version;
  final int port;
  final bool https;
  final String fingerprint;
  final String alias;
  final String? deviceModel;
  final DeviceType deviceType;
  final bool download;

  const Device({
    required this.ip,
    required this.version,
    required this.port,
    required this.https,
    required this.fingerprint,
    required this.alias,
    required this.deviceModel,
    required this.deviceType,
    required this.download,
  });
}
