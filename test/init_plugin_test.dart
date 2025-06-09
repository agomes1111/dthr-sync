import 'package:dthr_sync/dthr_sync.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    print('init_plugin_tests_starting');
  });

  test(
    'clock getter throws plugin not initialized if setupAppClock is not called',
    () async {
      expect(() => clock, throwsException);
    },
  );

  test(
    'clock getter loads correctly if setupAppClock is called',
    () async {
      setupAppClock(Settings('', 1));
      expect(() => clock, isNotNull);
    },
  );
}
