import 'package:equatable/equatable.dart';
import '../../domain/entities/project.dart';

enum ProjectsStatus { initial, loading, loaded, error }

class ProjectsState extends Equatable {
  final ProjectsStatus status;
  final List<Project> projects;
  final String errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.projects = const [],
    this.errorMessage = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<Project>? projects,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, projects, errorMessage, currentPage, hasReachedMax];
}
