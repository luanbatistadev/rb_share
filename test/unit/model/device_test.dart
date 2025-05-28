import 'package:common/common.dart';
import 'package:test/test.dart';

void main() {
  group('DeviceTypeMapper', () {
    test('should parse valid values', () {
      expect(DeviceTypeMapper.fromValue('mobile'), DeviceType.mobile);
      expect(DeviceTypeMapper.fromValue('desktop'), DeviceType.desktop);
      expect(DeviceTypeMapper.fromValue('web'), DeviceType.web);
      expect(DeviceTypeMapper.fromValue('headless'), DeviceType.headless);
      expect(DeviceTypeMapper.fromValue('server'), DeviceType.server);
    });

    test('should fallback to desktop for invalid values', () {
      expect(DeviceTypeMapper.fromValue('invalid'), DeviceType.desktop);
    });

    test('should encode values correctly', () {
      expect(DeviceType.mobile.toValue(), 'mobile');
      expect(DeviceType.desktop.toValue(), 'desktop');
      expect(DeviceType.web.toValue(), 'web');
      expect(DeviceType.headless.toValue(), 'headless');
      expect(DeviceType.server.toValue(), 'server');
    });
  });

  group('DeviceMapper', () {
    test('should parse from json', () {
      final json = {
        'ip': '192.168.1.1',
        'version': '1.0.0',
        'port': 8080,
        'https': true,
        'fingerprint': 'abc123',
        'alias': 'Test Device',
        'deviceModel': 'iPhone',
        'deviceType': 'mobile',
        'download': false,
      };

      final device = DeviceMapper.fromJson(json);

      expect(device.ip, '192.168.1.1');
      expect(device.version, '1.0.0');
      expect(device.port, 8080);
      expect(device.https, true);
      expect(device.fingerprint, 'abc123');
      expect(device.alias, 'Test Device');
      expect(device.deviceModel, 'iPhone');
      expect(device.deviceType, DeviceType.mobile);
      expect(device.download, false);
    });

    test('should serialize to json', () {
      const device = Device(
        ip: '192.168.1.1',
        version: '1.0.0',
        port: 8080,
        https: true,
        fingerprint: 'abc123',
        alias: 'Test Device',
        deviceModel: 'iPhone',
        deviceType: DeviceType.mobile,
        download: false,
      );

      final json = device.toJson();

      expect(json['ip'], '192.168.1.1');
      expect(json['version'], '1.0.0');
      expect(json['port'], 8080);
      expect(json['https'], true);
      expect(json['fingerprint'], 'abc123');
      expect(json['alias'], 'Test Device');
      expect(json['deviceModel'], 'iPhone');
      expect(json['deviceType'], 'mobile');
      expect(json['download'], false);
    });
  });
}
