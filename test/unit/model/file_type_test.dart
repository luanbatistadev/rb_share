import 'package:common/common.dart';
import 'package:test/test.dart';

void main() {
  group('FileTypeMapper', () {
    test('should parse valid values', () {
      expect(FileTypeMapper.fromValue('image'), FileType.image);
      expect(FileTypeMapper.fromValue('video'), FileType.video);
      expect(FileTypeMapper.fromValue('pdf'), FileType.pdf);
      expect(FileTypeMapper.fromValue('text'), FileType.text);
      expect(FileTypeMapper.fromValue('apk'), FileType.apk);
      expect(FileTypeMapper.fromValue('other'), FileType.other);
    });

    test('should fallback to other for invalid values', () {
      expect(FileTypeMapper.fromValue('invalid'), FileType.other);
    });

    test('should encode values correctly', () {
      expect(FileType.image.toValue(), 'image');
      expect(FileType.video.toValue(), 'video');
      expect(FileType.pdf.toValue(), 'pdf');
      expect(FileType.text.toValue(), 'text');
      expect(FileType.apk.toValue(), 'apk');
      expect(FileType.other.toValue(), 'other');
    });
  });
}
