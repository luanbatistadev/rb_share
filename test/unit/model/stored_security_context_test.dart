import 'package:common/common.dart';
import 'package:test/test.dart';

void main() {
  group('StoredSecurityContextMapper', () {
    test('should parse from json', () {
      final json = {
        'privateKey': 'private-key-123',
        'publicKey': 'public-key-456',
        'certificate': 'certificate-789',
        'certificateHash': 'hash-abc',
      };

      final context = StoredSecurityContext.fromJson(json);

      expect(context.privateKey, 'private-key-123');
      expect(context.publicKey, 'public-key-456');
      expect(context.certificate, 'certificate-789');
      expect(context.certificateHash, 'hash-abc');
    });

    test('should serialize to json', () {
      const context = StoredSecurityContext(
        privateKey: 'private-key-123',
        publicKey: 'public-key-456',
        certificate: 'certificate-789',
        certificateHash: 'hash-abc',
      );

      final json = context.toJson();

      expect(json['privateKey'], 'private-key-123');
      expect(json['publicKey'], 'public-key-456');
      expect(json['certificate'], 'certificate-789');
      expect(json['certificateHash'], 'hash-abc');
    });
  });
}
