import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/news_model.dart';
import 'package:dio/dio.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews({int page = 1, int perPage = 10});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient apiClient;

  NewsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NewsModel>> getNews({int page = 1, int perPage = 10}) async {
    try {
      final response = await apiClient.get(
        'posts',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          '_embed': true,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NewsModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Exception occurred');
    }
  }
}
