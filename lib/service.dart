import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dummy/common_values.dart';
import 'package:http/http.dart' as http;

network() async {
  final server = await HttpServer.bind('localhost', 8080);
  print('Listening on ${server.address}:${server.port}');

  await for (HttpRequest request in server) {
    try {
      // Add CORS headers to allow all origins, methods, and headers for OPTIONS requests
      request.response.headers
          .add('Access-Control-Allow-Origin', '*'); // Allow all origins
      request.response.headers.add('Access-Control-Allow-Methods',
          'GET, POST, PUT, DELETE, OPTIONS'); // Allow specified methods
      request.response.headers
          .add('Access-Control-Allow-Headers', '*'); // Allow specified headers
      request.response.headers.add('Access-Control-Allow-Credentials', 'true');
      request.response.headers.add('Allow', 'GET, POST, PUT, DELETE, OPTIONS');

      print(request.method);
      print(request.uri.path);

      if (request.method == 'OPTIONS') {
        request.response
          ..statusCode = HttpStatus.ok
          ..write('CORS preflight request handled.')
          ..close();
        continue; // Skip further processing for OPTIONS requests
      } else {
        if (request.uri.path == '/api/print' && request.method == 'POST' ||
            request.method == 'GET') {
          String requestBody = await utf8.decoder.bind(request).join();
          print('Received body: $requestBody');

          // Call another API with the received data
          //await callSecondApi(requestBody);
          String status = callSecondApi(requestBody) as String;

          if (status.contains("Error") ||
              status.contains("error") ||
              status.contains("Fail") ||
              status.contains("fail")) {
            request.response
              ..statusCode = HttpStatus.internalServerError
              ..write(status)
              ..close();
          } else {
            request.response
              ..statusCode = HttpStatus.ok
              ..write(status)
              ..close();
          }
        } else {
          request.response
            ..statusCode = HttpStatus.methodNotAllowed
            ..write('GET and POST Allowed.')
            ..close();
        }
      }
    } catch (e) {
      print('Error: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Error occurred while processing the request.')
        ..close();
    }
  }
}

Future<String> callSecondApi(String requestData) async {
  String status = "";
  try {
    final url = Uri.parse('http://$ipAddress:$portNumber/api/print');
    final response = await http.post(
      url,
      body: (requestData),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 6));

    if (response.statusCode == 200) {
      status = response.body.toString();
      print('Second API Response: ${response.body}');
    } else {
      status = response.body.toString();
      print('Failed to call the second API: ${response.statusCode}');
    }
  } on TimeoutException catch (e) {
    status = "Error:TIMEOUT";
    print('Timeout Error: $e');
    // Handle timeout error (e.g., display message to the user)
  } catch (e) {
    status = "Error:TRYCATCH";
    print('Error: $e');
    // Handle other types of errors
  }
  return status;
}