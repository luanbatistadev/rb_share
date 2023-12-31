import 'package:hive/hive.dart';
import 'package:rb_share/src/core/constansts/hive_type_constants.dart';

part 'shared_file_state.g.dart';

@HiveType(typeId: HiveTypeConstant.sharedFileState)
enum SharedFileState {
  @HiveField(0)
  none,
  @HiveField(1)
  downloading,
  @HiveField(2)
  uploading,
  @HiveField(3)
  available,
}