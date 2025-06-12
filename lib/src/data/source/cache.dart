import 'package:dthr_sync/src/data/dto/cache_data.dart';

class Cache implements LocalSource {
  CacheData? cacheDataMock;
  Future<bool> storeCacheDataMock(CacheData cache_data) async {
    // TODO: implement CacheData.toJson();
    cacheDataMock = cache_data;
    return true;
  }

  Future<CacheData?> fetchCacheDataMock() async {
    await Future.delayed(const Duration(seconds: 1));
    // final _cacheStoredDataString = 'cacheJson';
    // return CacheData.fromCacheMock(_cacheStoredDataString);
    return cacheDataMock;
  }

  Future<bool> hasStoredCacheDataMock() async {
    // TODO: implement check verification logic
    return cacheDataMock != null;
  }
}

abstract class LocalSource {
  Future<bool> storeCacheDataMock(CacheData cache_data);

  Future<CacheData?> fetchCacheDataMock();

  Future<bool> hasStoredCacheDataMock();
}
