import 'package:equatable/equatable.dart';

abstract class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchProjectDetailEvent extends ProjectDetailEvent {
  final String slug;

  const FetchProjectDetailEvent(this.slug);

  @override
  List<Object> get props => [slug];
}
