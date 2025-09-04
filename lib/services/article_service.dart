import 'dart:convert';
import 'package:http/http.dart' as http;

class ArticleService {
  static const String host = 'https://advweb-backend.vercel.app';

  Future<List> getAllArticles() async {
    try {
      final response = await http.get(
        Uri.parse('$host/api/articles'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

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
    final response = await http.post(
      Uri.parse('$host/api/articles'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(article),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final mapData = jsonDecode(response.body);
      return mapData;
    } else {
      throw Exception(
        'Failed to create article: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Map> updateArticle(String id, dynamic article) async {
    final response = await http.put(
      Uri.parse('$host/api/articles/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(article),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final mapData = jsonDecode(response.body);
      return mapData;
    } else {
      throw Exception(
        'Failed to update article: ${response.statusCode} ${response.body}',
      );
    }
  }
}
