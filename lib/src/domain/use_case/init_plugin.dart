import 'package:dthr_sync/dthr_sync.dart';
import 'package:dthr_sync/src/data/repo/data_repo.dart';
import 'package:dthr_sync/src/data/source/api.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';
import 'package:dthr_sync/src/domain/use_case/get_time.dart';

class InitPluginUseCase {
  Clock call(PluginSettings settings) {
    return Clock(
      GetTimeUseCase(
        DataRepo(
          apiSource: ApiSource(settings),
          cache: Cache(),
          loadedDataSingleton: RuntimeLoadedDataSingleton(null),
        ),
      ),
    );
  }
}
