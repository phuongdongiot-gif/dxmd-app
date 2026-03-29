import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<Project>>> getProjects({int page = 1, int perPage = 10});
  Future<Either<Failure, Project>> getProjectDetail(String slug);
}
