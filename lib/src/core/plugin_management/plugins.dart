import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:rb_share/src/core/constansts/hive_storage.dart';
import 'package:rb_share/src/core/utils/utility_functions.dart';

Future<void> initPlugins() async {
  if (UtilityFunctions.isMobile) {
    await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);
  }
  await HiveStorage().init();
}
