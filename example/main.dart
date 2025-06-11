import 'package:dthr_sync/dthr_sync.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupAppClock(
    Settings('fake.api.url', 5),
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
          stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((_) => clock.getTime()),
          builder: (context, snapshot) {
            return Text(
              snapshot.data?.toIso8601String() ?? 'Sincronizando...',
              style: const TextStyle(fontSize: 20),
            );
          },
        )),
      ),
    );
  }
}
