import 'package:common/common.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:test/test.dart';

void main() {
  MapperContainer.globals.use(PrepareUploadResponseDtoMapper.ensureInitialized());

  group('parse PrepareUploadResponseDto', () {
    test('should parse valid data', () {
      final dto = {
        'sessionId': 'session123',
        'files': {
          'file1': 'url1',
          'file2': 'url2',
        },
      };

      final parsed = PrepareUploadResponseDtoMapper.fromJson(dto);
      expect(parsed.sessionId, 'session123');
      expect(parsed.files.length, 2);
      expect(parsed.files['file1'], 'url1');
      expect(parsed.files['file2'], 'url2');
    });

    test('should handle empty files map', () {
      final dto = {
        'sessionId': 'session123',
        'files': {},
      };

      final parsed = PrepareUploadResponseDtoMapper.fromJson(dto);
      expect(parsed.sessionId, 'session123');
      expect(parsed.files.isEmpty, true);
    });
  });

  group('serialize PrepareUploadResponseDto', () {
    test('should serialize all fields', () {
      const dto = PrepareUploadResponseDto(
        sessionId: 'session123',
        files: {
          'file1': 'url1',
          'file2': 'url2',
        },
      );

      final serialized = dto.toJson();
      expect(serialized['sessionId'], 'session123');
      expect(serialized['files'].length, 2);
      expect(serialized['files']['file1'], 'url1');
      expect(serialized['files']['file2'], 'url2');
    });

    test('should serialize with empty files map', () {
      const dto = PrepareUploadResponseDto(
        sessionId: 'session123',
        files: {},
      );

      final serialized = dto.toJson();
      expect(serialized['sessionId'], 'session123');
      expect(serialized['files'], {});
    });
  });
}
