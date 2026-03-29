import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/project_model.dart';
import 'package:dio/dio.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects({int page = 1, int perPage = 10});
  Future<ProjectModel> getProjectDetail(String slug);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient apiClient;

  ProjectRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProjectModel>> getProjects({int page = 1, int perPage = 10}) async {
    try {
      final response = await apiClient.get(
        'du-an',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          '_embed': true, // To get featured media
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProjectModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Exception occurred');
    }
  }

  @override
  Future<ProjectModel> getProjectDetail(String slug) async {
    try {
      final response = await apiClient.get(
        'du-an',
        queryParameters: {
          'slug': slug,
          '_embed': true,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          return ProjectModel.fromJson(data.first as Map<String, dynamic>);
        } else {
          throw ServerException('Project not found');
        }
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Exception occurred');
    }
  }
}
