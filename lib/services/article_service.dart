import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ArticleService {
  static String get host {
    try {
      return dotenv.env['API_BASE_URL'] ?? 'https://advweb-backend.vercel.app';
    } catch (e) {
      print('Error accessing API_BASE_URL from env: $e');
      return 'https://advweb-backend.vercel.app';
    }
  }

  static int get timeout {
    try {
      return int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;
    } catch (e) {
      print('Error accessing API_TIMEOUT from env: $e');
      return 30000;
    }
  }

  Future<List> getAllArticles() async {
    try {
      final response = await http
          .get(
            Uri.parse('$host/api/articles'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(milliseconds: timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['articles'] ?? data ?? [];
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching articles: $e');
      // Return empty list on error
      return [];
    }
  }

  Future<Map> createArticle(dynamic article) async {
    try {
      final response = await http
          .post(
            Uri.parse('$host/api/articles'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(article),
          )
          .timeout(Duration(milliseconds: timeout));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final mapData = jsonDecode(response.body);
        return mapData;
      } else {
        // Parse error response for better error messages
        String errorMessage = 'Failed to create article';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['message'] != null) {
            String message = errorData['message'].toString();

            // Handle specific error types
            if (message.contains('E11000 duplicate key error')) {
              if (message.contains('name_1')) {
                errorMessage =
                    'An article with this name already exists. Please choose a different name.';
              } else {
                errorMessage =
                    'This article already exists. Please check the details and try again.';
              }
            } else if (message.contains('validation')) {
              errorMessage =
                  'Please check your input. Some required fields may be missing or invalid.';
            } else {
              errorMessage = message;
            }
          }
        } catch (e) {
          // If we can't parse the error response, use the raw response
          errorMessage = 'Failed to create article: ${response.statusCode}';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Request timed out. Please check your internet connection and try again.',
        );
      } else if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      } else {
        rethrow;
      }
    }
  }

  Future<Map> updateArticle(String id, dynamic article) async {
    try {
      final response = await http
          .put(
            Uri.parse('$host/api/articles/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(article),
          )
          .timeout(Duration(milliseconds: timeout));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final mapData = jsonDecode(response.body);
        return mapData;
      } else {
        // Parse error response for better error messages
        String errorMessage = 'Failed to update article';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['message'] != null) {
            String message = errorData['message'].toString();

            // Handle specific error types
            if (message.contains('E11000 duplicate key error')) {
              if (message.contains('name_1')) {
                errorMessage =
                    'An article with this name already exists. Please choose a different name.';
              } else {
                errorMessage =
                    'This article already exists. Please check the details and try again.';
              }
            } else if (message.contains('validation')) {
              errorMessage =
                  'Please check your input. Some required fields may be missing or invalid.';
            } else {
              errorMessage = message;
            }
          }
        } catch (e) {
          // If we can't parse the error response, use the raw response
          errorMessage = 'Failed to update article: ${response.statusCode}';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Request timed out. Please check your internet connection and try again.',
        );
      } else if (e.toString().contains('SocketException')) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      } else {
        rethrow;
      }
    }
  }
}
