import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/data/dto/cache_data.dart';
import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/data/source/api.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/repo/data_repo.dart';

class DataRepo implements DataRepository {
  @override
  ApiSource apiSource;
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
  Future<RuntimeLoadedData> getData() async {
    if (loadedDataSingleton.isLoaded()) {
      /// if there is already any loaded data: returns it
      return loadedDataSingleton.loadedData!;
    } else {
      /// if there is not any loaded data: fetchs data
      /// may take a while
      if (await cache.hasStoredCacheDataMock()) {
        CacheData _cacheData = await cache.fetchCacheDataMock();
        return _cacheData.toRuntimeData();
      } else {
        ApiTimeDto _apiTime = await apiSource.getApiTimeMock();
        return _apiTime.toRuntimeData(apiSource.settings);
      }
    }
  }
}
