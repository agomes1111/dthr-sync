import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';
import 'package:dthr_sync/src/data/repo/data_repo.dart';
import 'package:dthr_sync/src/data/source/api_source.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';
import 'package:dthr_sync/src/domain/entities/synced_clock.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:mocktail/mocktail.dart';

void expect(
  dynamic actual,
  dynamic matcher, {
  String? reason,
  dynamic skip,
}) {
  if (reason != null) {
    // Always show the reason, even on success
    print('   L ✔️  $reason ');
  }
  ft.expect(actual, matcher, reason: reason, skip: skip);
}

class MockApiSource extends Mock implements ApiSource {}

class MockCache extends Mock implements Cache {}

class MockRuntimeLoadedDataSingleton extends Mock implements RuntimeLoadedDataSingleton {}

class MockLoadedClock extends Mock implements SyncedClock {}

class MockSettings extends Mock implements PluginSettings {}

void main() {
  int syncInterval = 1;
  late MockApiSource mockApi;
  late MockCache mockCache;
  late MockRuntimeLoadedDataSingleton mockSingleton;
  late DataRepo dataRepoUnit;
  late Duration fakeNtwLatency;
  late ApiTimeDto apiTimeDto;

  late int ntwLatencySeconds;
  setUp(() {
    mockApi = MockApiSource();
    mockCache = MockCache();
    mockSingleton = MockRuntimeLoadedDataSingleton();
    dataRepoUnit = DataRepo(
      apiSource: mockApi,
      cache: mockCache,
      loadedDataSingleton: mockSingleton,
    );

    /// sets fake apis
    ntwLatencySeconds = 3;
    fakeNtwLatency = Duration(seconds: ntwLatencySeconds);
    apiTimeDto = ApiTimeDto(
      networkLatency: fakeNtwLatency,
      serverTimestamp: DateTime.now(),
    );
  });

  void _checkTimeStampDiff(timeStamp) {
    print('''
🧪 (ref.: ${DateTime.now()})
  L actual: ${timeStamp} (+${timeStamp?.difference(DateTime.now()).inSeconds})
  L expected: ${DateTime.now()}''');
    expect(
      timeStamp,
      isNotNull,
      reason: 'fetched time should not be null',
    );

    expect(
      timeStamp!.difference(DateTime.now()).inSeconds <= ntwLatencySeconds,
      true,
      reason:
          'diference between fetched timestamp and real timestamp should be less than ${ntwLatencySeconds}s',
    );
  }

  test(
    'Loads time from RuntimeData correctly - getData()',
    () async {
      /// mocks runtime singleton helper
      when(() => mockSingleton.isLoaded()).thenReturn(true);
      when(() => mockSingleton.loadedData).thenReturn(
        apiTimeDto.toRuntimeData(
          Settings(
            '',
            syncInterval,
          ),
        ),
      );

      /// simulates data beeing fetched
      final result = await dataRepoUnit.getData();

      /// tests if result type is correct
      expect(result.isLeft, true, reason: 'should load from Runtime');
      // if correct proceeds with tests
      if (result.isLeft) {
        /// verifies that mock singleton loadedData is called
        /// + and data is not loaded from API
        verify(() => mockSingleton.isLoaded()).called(1);
        verify(() => mockSingleton.loadedData).called(1);
        verifyNever(() => mockApi.getApiTimeMock());

        var lTimeStamp = result.left.loadedClock?.currentTime;
        _checkTimeStampDiff(lTimeStamp);
      }
    },
  );

  test(
    'Loads time from API correctly - getData()',
    () async {
      /// mocks runtime singleton helper
      when(() => mockSingleton.isLoaded()).thenReturn(false);

      /// mocks api timestamp return
      when(() => mockApi.getApiTimeMock()).thenAnswer(
        (_) async {
          await Future.delayed(fakeNtwLatency);
          return apiTimeDto;
        },
      );
      when(() => mockApi.settings).thenReturn(Settings(
        'fake_url',
        syncInterval,
      ));

      /// simulates data beeing fetched
      final result = await dataRepoUnit.getData();

      /// tests if result type is correct
      expect(result.isRight, true, reason: 'should load from API');
      // if correct proceeds with tests
      if (result.isRight) {
        /// verifies that mock singleton loadedData is not fetched
        /// + data is fetched from API
        verify(() => mockSingleton.isLoaded()).called(1);
        verifyNever(() => mockSingleton.loadedData);
        verify(() => mockApi.getApiTimeMock()).called(1);

        var rTimeStamp =
            result.right.toRuntimeData(dataRepoUnit.apiSource.settings).loadedClock?.currentTime;
        _checkTimeStampDiff(rTimeStamp);
      }
    },
  );

  test(
    '(no mocks) Loads the time first from the API, then from the Runtime singleton on subsequent calls. - getData()',
    () async {
      var _apiSource = ApiSource(
        Settings(
          '',
          syncInterval,
        ),
      );
      var _cache = Cache();
      var _loadedDataSingleton = RuntimeLoadedDataSingleton(null);

      dataRepoUnit = DataRepo(
        apiSource: _apiSource,
        cache: _cache,
        loadedDataSingleton: _loadedDataSingleton,
      );

      /// simulates data being fetched
      final shouldBeApiFetchedData = await dataRepoUnit.getData();

      /// checks if data was loaded from API
      expect(
        shouldBeApiFetchedData.isRight,
        true,
        reason: 'should load from API',
      );
      var svTimeStamp = shouldBeApiFetchedData.right.toRuntimeData(dataRepoUnit.apiSource.settings);
      _checkTimeStampDiff(svTimeStamp.loadedClock?.currentTime);

      ///fake sycn use case
      _loadedDataSingleton.updateLoadedData = svTimeStamp;

      if (shouldBeApiFetchedData.isRight) {
        var shouldBeRuntimeLoaded = await dataRepoUnit.getData();

        /// checks if data was loaded from Runtime (1)
        expect(
          shouldBeRuntimeLoaded.isLeft,
          true,
          reason: 'should load from Runtime (1)',
        );

        /// (2)
        shouldBeRuntimeLoaded = await dataRepoUnit.getData();
        expect(
          shouldBeRuntimeLoaded.isLeft,
          true,
          reason: 'should load from Runtime (2)',
        );
      }
    },
  );
}
