import 'package:get_it/get_it.dart';
import 'package:rb_share/src/core/constansts/api_service.dart';
import 'package:rb_share/src/core/constansts/clients/shared_file_client.dart';
import 'package:rb_share/src/core/constansts/global_scope_data.dart';
import 'package:rb_share/src/core/constansts/pref_data.dart';
import 'package:rb_share/src/core/repository/file_repository.dart';
import 'package:rb_share/src/core/service/download_service.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerSingleton<GlobalScopeData>(GlobalScopeData());
  getIt.registerSingleton<ApiService>(ApiService());
  getIt.registerSingleton<PrefData>(PrefData());
  getIt.registerSingleton<DownloadService>(DownloadService());

  // hive clients
  getIt.registerSingleton<SharedFileClient>(SharedFileClient());

  // repositories
  getIt.registerSingleton<FileRepository>(FileRepository(getIt.get<ApiService>()));
}
