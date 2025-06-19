import 'package:dthr_sync/src/domain/entities/synced_clock.dart';

class RuntimeClock extends SyncedClock {
  RuntimeClock({
    required super.serverTimestamp,
    required super.networkLatency,
  });
}
