import 'package:common/common.dart';
import 'package:test/test.dart';

void main() {
  group('FileStatus', () {
    test('should have correct values', () {
      expect(FileStatus.values.length, 5);
      expect(FileStatus.values, [
        FileStatus.queue,
        FileStatus.skipped,
        FileStatus.sending,
        FileStatus.failed,
        FileStatus.finished,
      ]);
    });
  });

  group('SessionStatus', () {
    test('should have correct values', () {
      expect(SessionStatus.values.length, 8);
      expect(SessionStatus.values, [
        SessionStatus.waiting,
        SessionStatus.recipientBusy,
        SessionStatus.declined,
        SessionStatus.sending,
        SessionStatus.finished,
        SessionStatus.finishedWithErrors,
        SessionStatus.canceledBySender,
        SessionStatus.canceledByReceiver,
      ]);
    });
  });
}
