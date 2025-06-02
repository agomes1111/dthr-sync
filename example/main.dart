import 'package:dthr_sync/dthr_sync.dart';
import 'package:flutter/material.dart';
import 'package:dthr_sync/src/dthr_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final clock = DthrService('http://127.0.0.1:8080/api/dthr');
  await clock.initialize();

  runApp(MyApp(clock: clock));
}

class MyApp extends StatelessWidget {
  final DthrService clock;

  const MyApp({super.key, required this.clock});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My DTHR Clock')),
        body: Center(
            child: StreamBuilder<DateTime?>(
          stream: Stream.periodic(const Duration(seconds: 1))
              .asyncMap((_) => clock.getCurrentDthr()),
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
