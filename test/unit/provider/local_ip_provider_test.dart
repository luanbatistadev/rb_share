import 'package:flutter_test/flutter_test.dart';
import 'package:rb_share/provider/local_ip_provider.dart';

void main() {
  group('rankIpAddresses', () {
    test('should return nativeResult if thirdPartyResult is null', () {
      final result = rankIpAddresses(['192.168.0.2', '192.168.0.1'], null);
      expect(result, ['192.168.0.2', '192.168.0.1']);
    });

    test('should return only thirdPartyResult if nativeResult is empty', () {
      final result = rankIpAddresses([], '192.168.0.5');
      expect(result, ['192.168.0.5']);
    });

    test('should merge and sort, .1 last if thirdPartyResult ends with .1', () {
      final result = rankIpAddresses(['192.168.0.2', '192.168.0.3'], '192.168.0.1');
      expect(result, ['192.168.0.2', '192.168.0.3', '192.168.0.1']);
    });

    test('should merge and prefer thirdPartyResult if not .1', () {
      final result = rankIpAddresses(['192.168.0.2', '192.168.0.3'], '192.168.0.5');
      expect(result, ['192.168.0.5', '192.168.0.2', '192.168.0.3']);
    });
  });
}
