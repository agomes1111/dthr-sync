import 'package:dthr_sync/src/data/dto/cache_data.dart';

class Cache {
  Future<bool> storeCacheDataMock(CacheData pluginSettings) async {
    // TODO: implement CacheData.toJson();
    return true;
  }

  Future<CacheData> fetchCacheDataMock() async {
    await Future.delayed(const Duration(seconds: 1));
    final _cacheStoredDataString = 'cacheJson';
    return CacheData.fromCacheMock(_cacheStoredDataString);
  }

  Future<bool> hasStoredCacheDataMock() async {
    // TODO: implement check verification logic
    return true;
  }
}
