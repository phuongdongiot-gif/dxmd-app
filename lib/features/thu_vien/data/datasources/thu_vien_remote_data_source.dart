import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/thu_vien_model.dart';
import 'package:dio/dio.dart';

abstract class ThuVienRemoteDataSource {
  Future<List<ThuVienModel>> getThuVien({int page = 1, int perPage = 14, int? categoryId});
}

class ThuVienRemoteDataSourceImpl implements ThuVienRemoteDataSource {
  final ApiClient apiClient;

  ThuVienRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ThuVienModel>> getThuVien({int page = 1, int perPage = 14, int? categoryId}) async {
    try {
      final Map<String, dynamic> params = {
        'page': page,
        'per_page': perPage,
        '_embed': true,
      };
      
      if (categoryId != null) {
        params['loai-thu-vien'] = categoryId;
      }

      final response = await apiClient.get(
        'thu-vien',
        queryParameters: params,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ThuVienModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Exception occurred');
    }
  }
}
