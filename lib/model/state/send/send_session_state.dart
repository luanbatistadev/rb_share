import 'package:common/common.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:dio/dio.dart';
import 'package:rb_share/model/state/send/sending_file.dart';

part 'send_session_state.mapper.dart';

@MappableClass()
class SendSessionState with SendSessionStateMappable {
  final String sessionId;
  final String? remoteSessionId; // v2
  final bool background;
  final SessionStatus status;
  final Device target;
  final Map<String, SendingFile> files; // file id as key
  final int? startTime;
  final int? endTime;
  final CancelToken? cancelToken;
  final String? errorMessage;

  const SendSessionState({
    required this.sessionId,
    required this.remoteSessionId,
    required this.background,
    required this.status,
    required this.target,
    required this.files,
    required this.startTime,
    required this.endTime,
    required this.cancelToken,
    required this.errorMessage,
  });

  /// Custom toString() to avoid printing the bytes.
  /// The default toString() does not respect the overridden toString() of
  /// SendingFile.
  @override
  String toString() {
    return 'SendSessionState(sessionId: $sessionId, remoteSessionId: $remoteSessionId, background: $background, status: $status, target: $target, files: $files, startTime: $startTime, endTime: $endTime, cancelToken: $cancelToken, errorMessage: $errorMessage)';
  }
}
