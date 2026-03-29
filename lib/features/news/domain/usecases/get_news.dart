import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetNews implements UseCase<List<News>, GetNewsParams> {
  final NewsRepository repository;

  GetNews(this.repository);

  @override
  Future<Either<Failure, List<News>>> call(GetNewsParams params) async {
    return await repository.getNews(page: params.page, perPage: params.perPage);
  }
}

class GetNewsParams extends Equatable {
  final int page;
  final int perPage;

  const GetNewsParams({this.page = 1, this.perPage = 10});

  @override
  List<Object> get props => [page, perPage];
}
