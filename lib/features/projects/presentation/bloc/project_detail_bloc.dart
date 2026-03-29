import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/project_repository.dart';
import 'project_detail_event.dart';
import 'project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectRepository repository;

  ProjectDetailBloc({required this.repository}) : super(const ProjectDetailState()) {
    on<FetchProjectDetailEvent>(_onFetchProjectDetail);
  }

  Future<void> _onFetchProjectDetail(
    FetchProjectDetailEvent event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProjectDetailStatus.loading, errorMessage: ''));

    final result = await repository.getProjectDetail(event.slug);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProjectDetailStatus.error,
        errorMessage: failure.message,
      )),
      (project) => emit(state.copyWith(
        status: ProjectDetailStatus.success,
        project: project,
      )),
    );
  }
}
