import 'package:hive/hive.dart';
import 'package:rb_share/src/core/entities/shared_file_entity.dart';
import 'package:rb_share/src/core/entities/shared_file_state.dart';

class HiveStorage {
  Future<void> init() async {
    Hive.init('doc');
    _registerAdapters();
  }

  void _registerAdapters() {
    Hive.registerAdapter(SharedFileStateAdapter());
    Hive.registerAdapter(SharedFileAdapter());
  }
}