import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/data/source/api.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';

abstract class DataRepository {
  ApiSource apiSource;
  Cache cache;
  RuntimeLoadedDataSingleton loadedDataSingleton;

  DataRepository({
    required this.apiSource,
    required this.cache,
    required this.loadedDataSingleton,
  });

  Future<RuntimeLoadedData> getData();
}
