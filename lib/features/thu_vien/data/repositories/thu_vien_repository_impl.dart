import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/thu_vien.dart';
import '../../domain/repositories/thu_vien_repository.dart';
import '../datasources/thu_vien_remote_data_source.dart';

class ThuVienRepositoryImpl implements ThuVienRepository {
  final ThuVienRemoteDataSource remoteDataSource;

  ThuVienRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ThuVien>>> getThuVien(int page, int perPage) async {
    try {
      final remoteData = await remoteDataSource.getThuVien(page: page, perPage: perPage);
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
