import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://ethqr.onrender.com/api/qr',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Map<String, dynamic>?> parseImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post('/parse-image', data: formData);

      if (response.statusCode == 200) {
        return response.data; // Dio automatically parses JSON to Map
      }
      return null;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      if (e.response != null) {
        print('Server Data: ${e.response?.data}');
      }
      return null;
    }
  }
  // Inside lib/api/api_service.dart

  Future<Map<String, dynamic>?> parseRawString(String qrText) async {
    print("Parsing raw QR string: $qrText");
    try {
      final response = await _dio.post(
        '/parse',
        data: qrText, // Sending raw string as @RequestBody
        options: Options(
          contentType: 'text/plain',
        ), // Ensure backend reads it right
      );

      if (response.statusCode == 200) {
        // If your service returns the Map directly (Tag 59, 62 etc.)
        return response.data is Map ? response.data : {'parsed': response.data};
      }
      return null;
    } on DioException catch (e) {
      print("Parsing Error: ${e.response?.data ?? e.message}");
      return null;
    }
  }
}
