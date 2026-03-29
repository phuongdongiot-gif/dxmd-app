import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/recruitment_model.dart';
import 'package:dio/dio.dart';

abstract class RecruitmentRemoteDataSource {
  Future<List<RecruitmentModel>> getRecruitments();
}

class RecruitmentRemoteDataSourceImpl implements RecruitmentRemoteDataSource {
  final ApiClient apiClient;

  RecruitmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<RecruitmentModel>> getRecruitments() async {
    try {
      final response = await apiClient.get(
        'tuyen-dung',
        queryParameters: {
          '_embed': true,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => RecruitmentModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Exception occurred');
    }
  }
}
