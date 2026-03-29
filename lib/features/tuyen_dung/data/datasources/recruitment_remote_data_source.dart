import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/recruitment_model.dart';
import 'package:dio/dio.dart';

abstract class RecruitmentRemoteDataSource {
  Future<RecruitmentModel> getRecruitments();
}

class RecruitmentRemoteDataSourceImpl implements RecruitmentRemoteDataSource {
  final ApiClient apiClient;

  RecruitmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RecruitmentModel> getRecruitments() async {
    try {
      final response = await apiClient.get(
        'pages',
        queryParameters: {
          'slug': 'tuyen-dung',
          '_embed': true,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          return RecruitmentModel.fromJson(data.first as Map<String, dynamic>);
        } else {
          throw ServerException('Page not found');
        }
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Exception occurred');
    }
  }
}
