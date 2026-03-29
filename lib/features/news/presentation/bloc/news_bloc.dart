import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_news.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;
  final int? categoryId;

  NewsBloc({required this.getNews, this.categoryId}) : super(const NewsState()) {
    on<FetchNewsEvent>(_onFetchNews);
    on<LoadMoreNewsEvent>(_onLoadMoreNews);
  }

  Future<void> _onFetchNews(FetchNewsEvent event, Emitter<NewsState> emit) async {
    emit(state.copyWith(status: NewsStatus.loading, currentPage: 1, hasReachedMax: false, newsList: []));

    final result = await getNews(GetNewsParams(page: 1, perPage: 10, categoryId: categoryId));

    result.fold(
      (failure) => emit(state.copyWith(status: NewsStatus.error, errorMessage: failure.message)),
      (newsListResponse) {
        emit(state.copyWith(
          status: NewsStatus.loaded,
          newsList: newsListResponse,
          hasReachedMax: newsListResponse.length < 10,
        ));
      },
    );
  }

  Future<void> _onLoadMoreNews(LoadMoreNewsEvent event, Emitter<NewsState> emit) async {
    if (state.hasReachedMax || state.status == NewsStatus.loading) return;

    final nextPage = state.currentPage + 1;
    final result = await getNews(GetNewsParams(page: nextPage, perPage: 10, categoryId: categoryId));

    result.fold(
      (failure) {
        emit(state.copyWith(status: NewsStatus.error, errorMessage: failure.message));
      },
      (newsListResponse) {
        if (newsListResponse.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(state.copyWith(
            status: NewsStatus.loaded,
            newsList: List.of(state.newsList)..addAll(newsListResponse),
            currentPage: nextPage,
            hasReachedMax: newsListResponse.length < 10,
          ));
        }
      },
    );
  }
}
