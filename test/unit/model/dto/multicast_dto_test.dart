import 'package:common/common.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:test/test.dart';

void main() {
  MapperContainer.globals.use(MulticastDtoMapper.ensureInitialized());

  group('parse MulticastDto', () {
    test('should parse valid data v2', () {
      final dto = {
        'alias': 'Test Device',
        'version': '2.0',
        'deviceModel': 'iPhone',
        'deviceType': 'mobile',
        'fingerprint': 'abc123',
        'port': 8080,
        'protocol': 'https',
        'download': true,
        'announce': true,
      };

      final parsed = MulticastDto.fromJson(dto);
      expect(parsed.alias, 'Test Device');
      expect(parsed.version, '2.0');
      expect(parsed.deviceModel, 'iPhone');
      expect(parsed.deviceType, DeviceType.mobile);
      expect(parsed.fingerprint, 'abc123');
      expect(parsed.port, 8080);
      expect(parsed.protocol, ProtocolType.https);
      expect(parsed.download, true);
      expect(parsed.announce, true);
      expect(parsed.announcement, null);
    });

    test('should parse valid data v1', () {
      final dto = {
        'alias': 'Test Device',
        'fingerprint': 'abc123',
        'announcement': true,
      };

      final parsed = MulticastDto.fromJson(dto);
      expect(parsed.alias, 'Test Device');
      expect(parsed.version, null);
      expect(parsed.deviceModel, null);
      expect(parsed.deviceType, null);
      expect(parsed.fingerprint, 'abc123');
      expect(parsed.port, null);
      expect(parsed.protocol, null);
      expect(parsed.download, null);
      expect(parsed.announce, null);
      expect(parsed.announcement, true);
    });

    test('should handle missing optional fields', () {
      final dto = {
        'alias': 'Test Device',
        'fingerprint': 'abc123',
      };

      final parsed = MulticastDto.fromJson(dto);
      expect(parsed.alias, 'Test Device');
      expect(parsed.version, null);
      expect(parsed.deviceModel, null);
      expect(parsed.deviceType, null);
      expect(parsed.fingerprint, 'abc123');
      expect(parsed.port, null);
      expect(parsed.protocol, null);
      expect(parsed.download, null);
      expect(parsed.announce, null);
      expect(parsed.announcement, null);
    });

    test('should fallback deviceType for invalid value', () {
      final dto = {
        'alias': 'Test Device',
        'fingerprint': 'abc123',
        'deviceType': 'invalidType',
      };

      final parsed = MulticastDto.fromJson(dto);
      expect(parsed.deviceType, DeviceType.desktop);
    });

    test('should fallback protocol for invalid value', () {
      final dto = {
        'alias': 'Test Device',
        'fingerprint': 'abc123',
        'protocol': 'invalidProtocol',
      };

      final parsed = MulticastDto.fromJson(dto);
      expect(parsed.protocol, ProtocolType.https);
    });
  });

  group('serialize MulticastDto', () {
    test('should serialize v2 data', () {
      const dto = MulticastDto(
        alias: 'Test Device',
        version: '2.0',
        deviceModel: 'iPhone',
        deviceType: DeviceType.mobile,
        fingerprint: 'abc123',
        port: 8080,
        protocol: ProtocolType.https,
        download: true,
        announce: true,
        announcement: null,
      );

      final serialized = dto.toJson();
      expect(serialized['alias'], 'Test Device');
      expect(serialized['version'], '2.0');
      expect(serialized['deviceModel'], 'iPhone');
      expect(serialized['deviceType'], 'mobile');
      expect(serialized['fingerprint'], 'abc123');
      expect(serialized['port'], 8080);
      expect(serialized['protocol'], 'https');
      expect(serialized['download'], true);
      expect(serialized['announce'], true);
      expect(serialized['announcement'], null);
    });

    test('should serialize v1 data', () {
      const dto = MulticastDto(
        alias: 'Test Device',
        version: null,
        deviceModel: null,
        deviceType: null,
        fingerprint: 'abc123',
        port: null,
        protocol: null,
        download: null,
        announce: null,
        announcement: true,
      );

      final serialized = dto.toJson();
      expect(serialized['alias'], 'Test Device');
      expect(serialized['fingerprint'], 'abc123');
      expect(serialized['announcement'], true);
      expect(serialized['version'], null);
      expect(serialized['deviceModel'], null);
      expect(serialized['deviceType'], null);
      expect(serialized['port'], null);
      expect(serialized['protocol'], null);
      expect(serialized['download'], null);
      expect(serialized['announce'], null);
    });
  });

  group('toDevice', () {
    test('should convert to Device with v2 data', () {
      const dto = MulticastDto(
        alias: 'Test Device',
        version: '2.0',
        deviceModel: 'iPhone',
        deviceType: DeviceType.mobile,
        fingerprint: 'abc123',
        port: 8080,
        protocol: ProtocolType.https,
        download: true,
        announce: true,
        announcement: null,
      );

      final device = dto.toDevice('192.168.1.1', 9090, false);
      expect(device.ip, '192.168.1.1');
      expect(device.version, '2.0');
      expect(device.port, 8080);
      expect(device.https, true);
      expect(device.fingerprint, 'abc123');
      expect(device.alias, 'Test Device');
      expect(device.deviceModel, 'iPhone');
      expect(device.deviceType, DeviceType.mobile);
      expect(device.download, true);
    });

    test('should convert to Device with v1 data', () {
      const dto = MulticastDto(
        alias: 'Test Device',
        version: null,
        deviceModel: null,
        deviceType: null,
        fingerprint: 'abc123',
        port: null,
        protocol: null,
        download: null,
        announce: null,
        announcement: true,
      );

      final device = dto.toDevice('192.168.1.1', 9090, true);
      expect(device.ip, '192.168.1.1');
      expect(device.version, fallbackProtocolVersion);
      expect(device.port, 9090);
      expect(device.https, true);
      expect(device.fingerprint, 'abc123');
      expect(device.alias, 'Test Device');
      expect(device.deviceModel, null);
      expect(device.deviceType, DeviceType.desktop);
      expect(device.download, false);
    });
  });
}
