import 'package:equatable/equatable.dart';
import '../../../projects/domain/entities/project.dart';
import '../../../news/domain/entities/news.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Project> featuredProjects;
  final List<News> latestNews;
  final String errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.featuredProjects = const [],
    this.latestNews = const [],
    this.errorMessage = '',
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Project>? featuredProjects,
    List<News>? latestNews,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      featuredProjects: featuredProjects ?? this.featuredProjects,
      latestNews: latestNews ?? this.latestNews,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, featuredProjects, latestNews, errorMessage];
}
