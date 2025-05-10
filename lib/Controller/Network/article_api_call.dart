// services/article_service.dart
import 'dart:developer';

import 'package:articleapptask/Model/article_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ArticleService {
  final Dio _dio = Dio();

  Future<List<ArticleModel>> fetchArticles() async {
    try {
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/posts');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          log("response :-> ${response.data}");
        }
        return (response.data as List)
            .map((json) => ArticleModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Bad response: ${e.response?.statusCode}');
      } else {
        throw Exception('Unexpected Dio error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}
