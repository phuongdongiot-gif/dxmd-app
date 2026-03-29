import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../news/domain/usecases/get_news.dart';
import '../../../projects/domain/usecases/get_projects.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProjects getProjects;
  final GetNews getNews;

  HomeBloc({
    required this.getProjects,
    required this.getNews,
  }) : super(const HomeState()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeDataEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    // Fetch projects and news simultaneously
    final projectsResult = await getProjects(const GetProjectsParams(page: 1, perPage: 5));
    final newsResult = await getNews(const GetNewsParams(page: 1, perPage: 5));

    projectsResult.fold(
      (failure) => emit(state.copyWith(status: HomeStatus.error, errorMessage: failure.message)),
      (projects) {
        newsResult.fold(
          (failure) => emit(state.copyWith(status: HomeStatus.error, errorMessage: failure.message)),
          (news) {
            emit(state.copyWith(
              status: HomeStatus.loaded,
              featuredProjects: projects,
              latestNews: news,
            ));
          },
        );
      },
    );
  }
}
