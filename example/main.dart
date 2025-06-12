import 'package:dthr_sync/dthr_sync.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupAppClock(
    /// sync timestamp everty 5 seconds
    Settings('http://your.server/api/dthr', 5),
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
            child: StreamBuilder<DateTime?>(
          stream: Stream.periodic(const Duration(seconds: 1))
              .asyncMap((_) async => await clock.getTime()),
          builder: (context, snapshot) {
            return Column(
              children: [
                snapshot.error != null
                    ? Text(snapshot.error.toString())
                    : Text(
                        snapshot.data != null
                            ? DateFormat('dd MMM yyyy, HH:mm:ss')
                                .format(DateTime.parse(snapshot.data!.toIso8601String()))
                            : 'Sincronizando...',
                        style: const TextStyle(fontSize: 20),
                      ),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.now()),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            );
          },
        )),
      ),
    );
  }
}
