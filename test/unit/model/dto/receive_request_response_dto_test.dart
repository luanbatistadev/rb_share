import 'package:common/common.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:test/test.dart';

void main() {
  MapperContainer.globals.use(ReceiveRequestResponseDtoMapper.ensureInitialized());
  MapperContainer.globals.use(const FileDtoMapper());
  MapperContainer.globals.use(InfoDtoMapper.ensureInitialized());

  group('parse ReceiveRequestResponseDto', () {
    test('should parse valid data', () {
      final dto = {
        'info': {
          'alias': 'Test Device',
          'version': '2.0',
          'deviceModel': 'iPhone',
          'deviceType': 'mobile',
          'fingerprint': 'abc123',
          'download': true,
        },
        'sessionId': 'session123',
        'files': {
          'file1': {
            'id': 'file1',
            'fileName': 'image.jpg',
            'size': 1234,
            'fileType': 'image/jpeg',
            'hash': 'abc123',
            'preview': 'base64preview',
          },
          'file2': {
            'id': 'file2',
            'fileName': 'document.pdf',
            'size': 5678,
            'fileType': 'application/pdf',
            'hash': 'def456',
            'preview': 'base64preview2',
          },
        },
      };

      final parsed = ReceiveRequestResponseDtoMapper.fromJson(dto);
      expect(parsed.info.alias, 'Test Device');
      expect(parsed.info.version, '2.0');
      expect(parsed.info.deviceModel, 'iPhone');
      expect(parsed.info.deviceType, DeviceType.mobile);
      expect(parsed.info.fingerprint, 'abc123');
      expect(parsed.info.download, true);
      expect(parsed.sessionId, 'session123');
      expect(parsed.files.length, 2);
      expect(parsed.files['file1']?.fileName, 'image.jpg');
      expect(parsed.files['file1']?.fileType, FileType.image);
      expect(parsed.files['file2']?.fileName, 'document.pdf');
      expect(parsed.files['file2']?.fileType, FileType.pdf);
    });

    test('should handle empty files map', () {
      final dto = {
        'info': {
          'alias': 'Test Device',
          'version': '2.0',
          'deviceModel': 'iPhone',
          'deviceType': 'mobile',
          'fingerprint': 'abc123',
          'download': true,
        },
        'sessionId': 'session123',
        'files': {},
      };

      final parsed = ReceiveRequestResponseDtoMapper.fromJson(dto);
      expect(parsed.info.alias, 'Test Device');
      expect(parsed.sessionId, 'session123');
      expect(parsed.files.isEmpty, true);
    });
  });

  group('serialize ReceiveRequestResponseDto', () {
    test('should serialize all fields', () {
      const dto = ReceiveRequestResponseDto(
        info: InfoDto(
          alias: 'Test Device',
          version: '2.0',
          deviceModel: 'iPhone',
          deviceType: DeviceType.mobile,
          fingerprint: 'abc123',
          download: true,
        ),
        sessionId: 'session123',
        files: {
          'file1': FileDto(
            id: 'file1',
            fileName: 'image.jpg',
            size: 1234,
            fileType: FileType.image,
            hash: 'abc123',
            preview: 'base64preview',
            legacy: false,
          ),
          'file2': FileDto(
            id: 'file2',
            fileName: 'document.pdf',
            size: 5678,
            fileType: FileType.pdf,
            hash: 'def456',
            preview: 'base64preview2',
            legacy: false,
          ),
        },
      );

      final serialized = dto.toJson();
      expect(serialized['info']['alias'], 'Test Device');
      expect(serialized['info']['version'], '2.0');
      expect(serialized['info']['deviceModel'], 'iPhone');
      expect(serialized['info']['deviceType'], 'mobile');
      expect(serialized['info']['fingerprint'], 'abc123');
      expect(serialized['info']['download'], true);
      expect(serialized['sessionId'], 'session123');
      expect(serialized['files'].length, 2);
      expect(serialized['files']['file1']['fileName'], 'image.jpg');
      expect(serialized['files']['file1']['fileType'], 'image/jpeg');
      expect(serialized['files']['file2']['fileName'], 'document.pdf');
      expect(serialized['files']['file2']['fileType'], 'application/pdf');
    });

    test('should serialize with empty files map', () {
      const dto = ReceiveRequestResponseDto(
        info: InfoDto(
          alias: 'Test Device',
          version: '2.0',
          deviceModel: 'iPhone',
          deviceType: DeviceType.mobile,
          fingerprint: 'abc123',
          download: true,
        ),
        sessionId: 'session123',
        files: {},
      );

      final serialized = dto.toJson();
      expect(serialized['info']['alias'], 'Test Device');
      expect(serialized['sessionId'], 'session123');
      expect(serialized['files'], {});
    });
  });
}
