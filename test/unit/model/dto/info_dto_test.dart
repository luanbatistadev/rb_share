import 'package:common/common.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:test/test.dart';

void main() {
  MapperContainer.globals.use(InfoDtoMapper.ensureInitialized());

  group('parse InfoDto', () {
    test('should parse valid data', () {
      final dto = {
        'alias': 'Test Device',
        'version': '1.0.0',
        'deviceModel': 'iPhone',
        'deviceType': 'mobile',
        'fingerprint': 'abc123',
        'download': true,
      };

      final parsed = InfoDto.fromJson(dto);
      expect(parsed.alias, 'Test Device');
      expect(parsed.version, '1.0.0');
      expect(parsed.deviceModel, 'iPhone');
      expect(parsed.deviceType, DeviceType.mobile);
      expect(parsed.fingerprint, 'abc123');
      expect(parsed.download, true);
    });

    test('should handle missing optional fields', () {
      final dto = {
        'alias': 'Test Device',
        'version': null,
        'deviceModel': null,
        'deviceType': null,
        'fingerprint': null,
        'download': null,
      };

      final parsed = InfoDto.fromJson(dto);
      expect(parsed.alias, 'Test Device');
      expect(parsed.version, null);
      expect(parsed.deviceModel, null);
      expect(parsed.deviceType, null);
      expect(parsed.fingerprint, null);
      expect(parsed.download, null);
    });

    test('should fallback deviceType for invalid value', () {
      final dto = {
        'alias': 'Test Device',
        'version': null,
        'deviceModel': null,
        'deviceType': 'invalidType',
        'fingerprint': null,
        'download': null,
      };

      final parsed = InfoDto.fromJson(dto);
      expect(parsed.deviceType, DeviceType.desktop);
    });
  });

  group('serialize InfoDto', () {
    test('should serialize all fields', () {
      const dto = InfoDto(
        alias: 'Test Device',
        version: '1.0.0',
        deviceModel: 'iPhone',
        deviceType: DeviceType.mobile,
        fingerprint: 'abc123',
        download: true,
      );

      final serialized = dto.toJson();
      expect(serialized['alias'], 'Test Device');
      expect(serialized['version'], '1.0.0');
      expect(serialized['deviceModel'], 'iPhone');
      expect(serialized['deviceType'], 'mobile');
      expect(serialized['fingerprint'], 'abc123');
      expect(serialized['download'], true);
    });

    test('should serialize with null fields', () {
      const dto = InfoDto(
        alias: 'Test Device',
        version: null,
        deviceModel: null,
        deviceType: null,
        fingerprint: null,
        download: null,
      );

      final serialized = dto.toJson();
      expect(serialized['alias'], 'Test Device');
      expect(serialized['version'], null);
      expect(serialized['deviceModel'], null);
      expect(serialized['deviceType'], null);
      expect(serialized['fingerprint'], null);
      expect(serialized['download'], null);
    });
  });
}
