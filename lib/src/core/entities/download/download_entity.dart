import 'package:equatable/equatable.dart';
import 'package:rb_share/src/core/entities/download/download_manner.dart';
import 'package:rb_share/src/core/entities/download/download_state.dart';

class DownloadEntity extends Equatable {
  final String id;
  final String fileName;
  final String url;
  final String savedDir;
  final DownloadManner manner;
  final DownloadState state;

  const DownloadEntity(
    this.id,
    this.fileName,
    this.url,
    this.savedDir,
    this.manner,
    this.state,
  );

  @override
  List<Object> get props => [id, fileName, url, savedDir, manner, state];
}