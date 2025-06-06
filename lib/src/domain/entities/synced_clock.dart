typedef ElapsedProvider = Duration Function();

abstract class SyncedClock {
  final DateTime serverTimestamp;
  final Duration networkLatency;
  final ElapsedProvider elapsedProvider;

  SyncedClock({
    required this.serverTimestamp,
    required this.networkLatency,
    ElapsedProvider? elapsedProv,
  }) : elapsedProvider = elapsedProv ??
            (() {
              final sw = Stopwatch()..start();
              return () => sw.elapsed;
            }());

  DateTime get _adjustedTimestamp => serverTimestamp.add(networkLatency);

  DateTime get currentTime => _adjustedTimestamp.add(elapsedProvider());
}
