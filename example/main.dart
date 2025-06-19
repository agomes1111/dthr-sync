// ignore_for_file: unused_local_variable

import 'package:dthr_sync/multiple_clocks.dart';
import 'package:flutter/material.dart';

final String CLOK_O = 'id_0';
final String CLOK_1 = 'id_1';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  startClock(
    CLOK_O,
    Settings(
      api_url: 'api_url1',
      autoSync: false,
      syncJobInterval: 1,
    ),
  );

  startClock(
    CLOK_1,
    Settings(
      api_url: 'api_url2',
      autoSync: false,
      syncJobInterval: 2,
    ),
  );

  clocksHandler.updateClockTimeStampById(
    DateTime.now().add(Duration(hours: 1, minutes: 22)),
    Duration(milliseconds: 1500),
    CLOK_O,
  );

  clocksHandler.updateClockTimeStampById(
    DateTime.now().add(Duration(minutes: 1)),
    Duration(milliseconds: 1000),
    CLOK_1,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My DTHR Clock')),
        body: Center(
            child: Column(
          children: [
            /// CLOCK 0
            Text('CLOCK - 1'),
            StreamBuilder<DateTime?>(
              stream: Stream.periodic(const Duration(seconds: 1))
                  .asyncMap((_) async => await clocksHandler.getTimeById(CLOK_O)),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    snapshot.error != null
                        ? Text(snapshot.error.toString())
                        : Text(
                            snapshot.data != null
                                ? snapshot.data!.toIso8601String()
                                : 'Sincronizando...',
                            style: const TextStyle(fontSize: 20),
                          ),
                    Text(
                      DateTime.now().toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              },
            ),

            /// CLOCK 1
            Text('CLOCK - 2'),
            StreamBuilder<DateTime?>(
              stream: Stream.periodic(const Duration(seconds: 1))
                  .asyncMap((_) async => await clocksHandler.getTimeById(CLOK_1)),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    snapshot.error != null
                        ? Text(snapshot.error.toString())
                        : Text(
                            snapshot.data != null
                                ? snapshot.data!.toIso8601String()
                                : 'Sincronizando...',
                            style: const TextStyle(fontSize: 20),
                          ),
                    Text(
                      DateTime.now().toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              },
            ),
          ],
        )),
      ),
    );
  }
}
