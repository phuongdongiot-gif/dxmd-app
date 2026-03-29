import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/recruitment.dart';
import '../../domain/repositories/recruitment_repository.dart';
import '../datasources/recruitment_remote_data_source.dart';

class RecruitmentRepositoryImpl implements RecruitmentRepository {
  final RecruitmentRemoteDataSource remoteDataSource;

  RecruitmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Recruitment>> getRecruitments() async {
    try {
      final remoteData = await remoteDataSource.getRecruitments();
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
