import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjects implements UseCase<List<Project>, GetProjectsParams> {
  final ProjectRepository repository;

  GetProjects(this.repository);

  @override
  Future<Either<Failure, List<Project>>> call(GetProjectsParams params) async {
    return await repository.getProjects(page: params.page, perPage: params.perPage);
  }
}

class GetProjectsParams extends Equatable {
  final int page;
  final int perPage;

  const GetProjectsParams({this.page = 1, this.perPage = 10});

  @override
  List<Object> get props => [page, perPage];
}
