import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recruitment.dart';
import '../repositories/recruitment_repository.dart';

class GetRecruitments implements UseCase<List<Recruitment>, NoParams> {
  final RecruitmentRepository repository;

  GetRecruitments(this.repository);

  @override
  Future<Either<Failure, List<Recruitment>>> call(NoParams params) async {
    return await repository.getRecruitments();
  }
}
