import 'package:equatable/equatable.dart';
import '../../domain/entities/news.dart';

enum NewsStatus { initial, loading, loaded, error }

class NewsState extends Equatable {
  final NewsStatus status;
  final List<News> newsList;
  final String errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const NewsState({
    this.status = NewsStatus.initial,
    this.newsList = const [],
    this.errorMessage = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  NewsState copyWith({
    NewsStatus? status,
    List<News>? newsList,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return NewsState(
      status: status ?? this.status,
      newsList: newsList ?? this.newsList,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, newsList, errorMessage, currentPage, hasReachedMax];
}
