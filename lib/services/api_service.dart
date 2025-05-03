import 'dart:convert';
import 'dart:io';
import 'package:castify_studio/utils/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

class ApiService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final logger = Logger();

  Future<String?> _getToken() async {
    return await SharedPrefs.getAccessToken();
  }

  Future<Map<String, String>> _headers({Map<String, String>? extra}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (extra != null) ...extra,
    };

    final token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<dynamic> get(
    String path, {
      Map<String, String>? headers,
      Map<String, String>? queryParams
    }) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: await _headers(extra: headers));
    return _processResponse(response);
  }

  Future<dynamic> post(String path, dynamic body,
    {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await http.post(
      uri,
      headers: await _headers(extra: headers),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  Future<dynamic> put(String path, dynamic body,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await http.put(
      uri,
      headers: await _headers(extra: headers),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }
  Future<String> putText(String path, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await http.put(
      uri,
      headers: await _headers(extra: headers),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body; // plain text
    } else {
      throw HttpException('Failed with status code ${response.statusCode}: ${response.body}');
    }
  }

  Future<dynamic> delete(String path, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await http.delete(uri, headers: await _headers(extra: headers));
    return _processResponse(response);
  }

  Future<dynamic> postMultipart(String path, FormData formData) async {
    final token = await _getToken();
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      },
    ));

    try {
      final response = await dio.post(path, data: formData);
      return response.data;
    } on DioException catch (e) {
      logger.e('Error: ${e.message}');
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['message'] ?? 'Failed',
      );
    }
  }

  Future<dynamic> putMultipart(String path, FormData formData) async {
    final token = await _getToken();
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      },
    ));

    try {
      final response = await dio.put(path, data: formData);
      return response.data;
    } on DioException catch (e) {
      logger.e('Error: ${e.message}');
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['message'] ?? 'Failed',
      );
    }
  }

  Future<dynamic> deleteWithBody(String path, dynamic body) async {
    final token = await _getToken();
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ));

    try {
      final response = await dio.delete(path, data: body);
      return response.data;
    } on DioException catch (e) {
      logger.e('Error: ${e.message}');
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['message'] ?? 'Failed',
      );
    }
  }

  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (kDebugMode) {
      print('[API] ${response.request?.url} (${response.statusCode})');
    }

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      throw ApiException(
        statusCode: statusCode,
        message: body?['message'] ?? 'Unexpected error',
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}