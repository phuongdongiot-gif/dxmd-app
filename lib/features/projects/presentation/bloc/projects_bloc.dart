import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_projects.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjects getProjects;

  ProjectsBloc({required this.getProjects}) : super(const ProjectsState()) {
    on<FetchProjectsEvent>(_onFetchProjects);
    on<LoadMoreProjectsEvent>(_onLoadMoreProjects);
  }

  Future<void> _onFetchProjects(FetchProjectsEvent event, Emitter<ProjectsState> emit) async {
    emit(state.copyWith(status: ProjectsStatus.loading, currentPage: 1, hasReachedMax: false, projects: []));

    final result = await getProjects(const GetProjectsParams(page: 1, perPage: 10));

    result.fold(
      (failure) => emit(state.copyWith(status: ProjectsStatus.error, errorMessage: failure.message)),
      (projectsList) {
        emit(state.copyWith(
          status: ProjectsStatus.loaded,
          projects: projectsList,
          hasReachedMax: projectsList.length < 10,
        ));
      },
    );
  }

  Future<void> _onLoadMoreProjects(LoadMoreProjectsEvent event, Emitter<ProjectsState> emit) async {
    if (state.hasReachedMax || state.status == ProjectsStatus.loading) return;

    final nextPage = state.currentPage + 1;
    final result = await getProjects(GetProjectsParams(page: nextPage, perPage: 10));

    result.fold(
      (failure) {
        // Can emit error or just ignore to not break current list
        emit(state.copyWith(status: ProjectsStatus.error, errorMessage: failure.message));
      },
      (projectsList) {
        if (projectsList.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(state.copyWith(
            status: ProjectsStatus.loaded,
            projects: List.of(state.projects)..addAll(projectsList),
            currentPage: nextPage,
            hasReachedMax: projectsList.length < 10,
          ));
        }
      },
    );
  }
}
