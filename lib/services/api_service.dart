import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/subcategory.dart';
import '../models/word.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String baseUrl = 'https://cms.cmv.md/api/public';

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> categoriesJson = jsonData['data'];
          return categoriesJson.map((json) => Category.fromJson(json)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<List<SubCategory>> fetchSubCategories(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/category/$categoryId/subcategories'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> subCategoriesJson = jsonData['data'];
          return subCategoriesJson
              .map((json) => SubCategory.fromJson(json))
              .toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load subcategories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

  Future<List<Word>> fetchWords({
    required String categoryId,
    Language? language,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = {
        'categoryId': categoryId,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (language != null) {
        queryParams['language'] = language.value.toString();
      }

      final uri = Uri.parse(
        '$baseUrl/words',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: {'accept': '*/*'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> wordsJson = jsonData['data'];
          return wordsJson.map((json) => Word.fromJson(json)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load words: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching words: $e');
    }
  }
}
