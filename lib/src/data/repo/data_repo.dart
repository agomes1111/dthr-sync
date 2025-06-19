import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/data/source/api_source.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';
import 'package:dthr_sync/src/domain/repo/data_repo.dart';
import 'package:either_dart/either.dart';
import 'package:collection/collection.dart';

class DataRepo implements DataRepository {
  @override
  ApiSource? apiSource;
  @override
  Cache cache;
  @override
  RuntimeLoadedDataSingleton loadedDataSingleton;

  DataRepo({
    required this.apiSource,
    required this.cache,
    required this.loadedDataSingleton,
  });

  @override
  Future<Either<RuntimeData, ApiTimeDto>> getDataById(String id) async {
    if (loadedDataSingleton.isLoaded()) {
      /// if there is already any loaded data: returns it
      print('fetching_loaded_timestamp');
      RuntimeData? runtimeData = loadedDataSingleton.loadedData?.runtimeLoadedData
          .firstWhereOrNull((item) => item.id == id);
      if (runtimeData != null) {
        return Left(runtimeData);
      } else {
        throw Exception('could_not_fetch_loaded_timestamp');
      }
    } else {
      /// if there is not any data loaded fetchs from API
      // evita chamadas concorrentes
      if (loadedDataSingleton.lock) {
        print('concurrent_call');
        throw Exception('concurrent_fetching_calls');
      } else {
        try {
          if (apiSource == null) {
            throw Exception('data_repo_api_source_not_provided');
          }
          loadedDataSingleton.lock = true;
          ApiTimeDto _apiTime = await apiSource!.getSvTimeStamp();
          print('returnin_server_timestamp');
          loadedDataSingleton.lock = false;
          loadedDataSingleton.updateLoadedData = _apiTime.toRuntimeData(apiSource!.settings);
          return Right(_apiTime);
        } catch (err) {
          loadedDataSingleton.lock = false;
          rethrow;
        }
      }
    }
  }
}
