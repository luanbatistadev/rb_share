import 'package:common/common.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:test/test.dart';

void main() {
  MapperContainer.globals.use(const FileDtoMapper());

  group('parse FileDto', () {
    test('should parse valid data with mime type', () {
      final dto = {
        'id': 'file1',
        'fileName': 'image.jpg',
        'size': 1234,
        'fileType': 'image/jpeg',
        'hash': 'abc123',
        'preview': 'base64preview',
      };

      final parsed = const FileDtoMapper().decode(dto);
      expect(parsed.id, 'file1');
      expect(parsed.fileName, 'image.jpg');
      expect(parsed.size, 1234);
      expect(parsed.fileType, FileType.image);
      expect(parsed.hash, 'abc123');
      expect(parsed.preview, 'base64preview');
      expect(parsed.legacy, false);
    });

    test('should parse valid data with legacy enum', () {
      final dto = {
        'id': 'file1',
        'fileName': 'image.jpg',
        'size': 1234,
        'fileType': 'image',
        'hash': 'abc123',
        'preview': 'base64preview',
      };

      final parsed = const FileDtoMapper().decode(dto);
      expect(parsed.id, 'file1');
      expect(parsed.fileName, 'image.jpg');
      expect(parsed.size, 1234);
      expect(parsed.fileType, FileType.image);
      expect(parsed.hash, 'abc123');
      expect(parsed.preview, 'base64preview');
      expect(parsed.legacy, false);
    });

    test('should handle missing optional fields', () {
      final dto = {
        'id': 'file1',
        'fileName': 'image.jpg',
        'size': 1234,
        'fileType': 'image/jpeg',
      };

      final parsed = const FileDtoMapper().decode(dto);
      expect(parsed.id, 'file1');
      expect(parsed.fileName, 'image.jpg');
      expect(parsed.size, 1234);
      expect(parsed.fileType, FileType.image);
      expect(parsed.hash, null);
      expect(parsed.preview, null);
      expect(parsed.legacy, false);
    });

    test('should handle unknown mime type', () {
      final dto = {
        'id': 'file1',
        'fileName': 'unknown.xyz',
        'size': 1234,
        'fileType': 'application/xyz',
      };

      final parsed = const FileDtoMapper().decode(dto);
      expect(parsed.fileType, FileType.other);
    });

    test('should handle unknown legacy enum', () {
      final dto = {
        'id': 'file1',
        'fileName': 'unknown.xyz',
        'size': 1234,
        'fileType': 'unknown',
      };

      final parsed = const FileDtoMapper().decode(dto);
      expect(parsed.fileType, FileType.other);
    });
  });

  group('serialize FileDto', () {
    test('should serialize with mime type', () {
      const dto = FileDto(
        id: 'file1',
        fileName: 'image.jpg',
        size: 1234,
        fileType: FileType.image,
        hash: 'abc123',
        preview: 'base64preview',
        legacy: false,
      );

      final serialized = const FileDtoMapper().encode(dto);
      expect(serialized['id'], 'file1');
      expect(serialized['fileName'], 'image.jpg');
      expect(serialized['size'], 1234);
      expect(serialized['fileType'], 'image/jpeg');
      expect(serialized['hash'], 'abc123');
      expect(serialized['preview'], 'base64preview');
    });

    test('should serialize with legacy enum', () {
      const dto = FileDto(
        id: 'file1',
        fileName: 'image.jpg',
        size: 1234,
        fileType: FileType.image,
        hash: 'abc123',
        preview: 'base64preview',
        legacy: true,
      );

      final serialized = const FileDtoMapper().encode(dto);
      expect(serialized['id'], 'file1');
      expect(serialized['fileName'], 'image.jpg');
      expect(serialized['size'], 1234);
      expect(serialized['fileType'], 'image');
      expect(serialized['hash'], 'abc123');
      expect(serialized['preview'], 'base64preview');
    });

    test('should serialize without optional fields', () {
      const dto = FileDto(
        id: 'file1',
        fileName: 'image.jpg',
        size: 1234,
        fileType: FileType.image,
        hash: null,
        preview: null,
        legacy: false,
      );

      final serialized = const FileDtoMapper().encode(dto);
      expect(serialized['id'], 'file1');
      expect(serialized['fileName'], 'image.jpg');
      expect(serialized['size'], 1234);
      expect(serialized['fileType'], 'image/jpeg');
      expect(serialized.containsKey('hash'), false);
      expect(serialized.containsKey('preview'), false);
    });
  });
}
