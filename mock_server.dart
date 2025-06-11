import 'dart:convert';
import 'dart:io';

void main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('🕒 DTHR Test Server running on http://localhost:8080');

  await for (HttpRequest request in server) {
    // Add CORS headers to all responses
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Origin, Content-Type');

    // Handle preflight request
    if (request.method == 'OPTIONS') {
      request.response
        ..statusCode = HttpStatus.noContent
        ..close();
      continue;
    }
    print('request_received_${request.requestedUri}');
    await Future.delayed(const Duration(seconds: 15));
    // Handle GET /api/dthr
    if (request.method == 'GET' && request.uri.path == '/api/dthr') {
      final now = DateTime.now().toUtc();
      final response = jsonEncode({'dthr': now.toIso8601String()});

      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(response)
        ..close();
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not found')
        ..close();
    }
  }
}
