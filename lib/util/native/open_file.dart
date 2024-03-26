import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:rb_share/util/native/platform_check.dart';
import 'package:rb_share/widget/dialogs/cannot_open_file_dialog.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

/// Opens the selected file which is stored on the device.
Future<void> openFile(
  BuildContext context,
  FileType fileType,
  String filePath, {
  void Function()? onDeleteTap,
}) async {
  if ((fileType == FileType.apk || filePath.toLowerCase().endsWith('.apk')) &&
      checkPlatform([TargetPlatform.android])) {
    await Permission.requestInstallPackages.request();
  }
  final fileOpenResult = await OpenFilex.open(filePath);
  if (fileOpenResult.type != ResultType.done && context.mounted) {
    await CannotOpenFileDialog.open(context, filePath, onDeleteTap);
  }
}
