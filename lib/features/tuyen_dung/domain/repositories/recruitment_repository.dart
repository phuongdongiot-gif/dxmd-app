import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recruitment.dart';

abstract class RecruitmentRepository {
  Future<Either<Failure, List<Recruitment>>> getRecruitments();
}
