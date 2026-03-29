import 'package:equatable/equatable.dart';
import '../../domain/entities/project.dart';

enum ProjectDetailStatus { initial, loading, success, error }

class ProjectDetailState extends Equatable {
  final ProjectDetailStatus status;
  final Project? project;
  final String? errorMessage;

  const ProjectDetailState({
    this.status = ProjectDetailStatus.initial,
    this.project,
    this.errorMessage,
  });

  ProjectDetailState copyWith({
    ProjectDetailStatus? status,
    Project? project,
    String? errorMessage,
  }) {
    return ProjectDetailState(
      status: status ?? this.status,
      project: project ?? this.project,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, project, errorMessage];
}
