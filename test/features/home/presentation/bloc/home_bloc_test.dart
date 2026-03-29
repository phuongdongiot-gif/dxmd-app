import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dxmd_app/core/error/failures.dart';
import 'package:dxmd_app/features/news/domain/entities/news.dart';
import 'package:dxmd_app/features/projects/domain/entities/project.dart';
import 'package:dxmd_app/features/projects/domain/usecases/get_projects.dart';
import 'package:dxmd_app/features/news/domain/usecases/get_news.dart';
import 'package:dxmd_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:dxmd_app/features/home/presentation/bloc/home_event.dart';
import 'package:dxmd_app/features/home/presentation/bloc/home_state.dart';

class MockGetProjects extends Mock implements GetProjects {}
class MockGetNews extends Mock implements GetNews {}

void main() {
  late HomeBloc homeBloc;
  late MockGetProjects mockGetProjects;
  late MockGetNews mockGetNews;

  setUp(() {
    mockGetProjects = MockGetProjects();
    mockGetNews = MockGetNews();
    homeBloc = HomeBloc(
      getProjects: mockGetProjects,
      getNews: mockGetNews,
    );
  });

  tearDown(() {
    homeBloc.close();
  });

  final tProjectList = <Project>[
    const Project(
      id: 1,
      title: 'Project 1',
      slug: 'project-1',
      content: 'Content',
    )
  ];
  final tNewsList = <News>[
    const News(id: 1, title: 'News 1', content: 'Content', excerpt: 'Excerpt', slug: 'slug')
  ];

  setUpAll(() {
    registerFallbackValue(const GetProjectsParams(page: 1, perPage: 5));
    registerFallbackValue(const GetNewsParams(page: 1, perPage: 5));
  });

  test('initial state should be HomeState with HomeStatus.initial', () {
    expect(homeBloc.state, const HomeState(status: HomeStatus.initial));
  });

  blocTest<HomeBloc, HomeState>(
    'emits [HomeStatus.loading, HomeStatus.loaded] when LoadHomeDataEvent is added and usecases succeed',
    build: () {
      when(() => mockGetProjects(any())).thenAnswer((_) async => Right(tProjectList));
      when(() => mockGetNews(any())).thenAnswer((_) async => Right(tNewsList));
      return homeBloc;
    },
    act: (bloc) => bloc.add(LoadHomeDataEvent()),
    expect: () => [
      const HomeState(status: HomeStatus.loading),
      HomeState(status: HomeStatus.loaded, featuredProjects: tProjectList, latestNews: tNewsList),
    ],
    verify: (_) {
      verify(() => mockGetProjects(const GetProjectsParams(page: 1, perPage: 5))).called(1);
      verify(() => mockGetNews(const GetNewsParams(page: 1, perPage: 5))).called(1);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeStatus.loading, HomeStatus.error] when getProjects fails',
    build: () {
      when(() => mockGetProjects(any())).thenAnswer((_) async => const Left(ServerFailure('Lỗi Server Dự Án')));
      when(() => mockGetNews(any())).thenAnswer((_) async => Right(tNewsList));
      return homeBloc;
    },
    act: (bloc) => bloc.add(LoadHomeDataEvent()),
    expect: () => [
      const HomeState(status: HomeStatus.loading),
      const HomeState(status: HomeStatus.error, errorMessage: 'Lỗi Server Dự Án'),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeStatus.loading, HomeStatus.error] when getNews fails (projects succeed)',
    build: () {
      when(() => mockGetProjects(any())).thenAnswer((_) async => Right(tProjectList));
      when(() => mockGetNews(any())).thenAnswer((_) async => const Left(ServerFailure('Lỗi Server Tin Tức')));
      return homeBloc;
    },
    act: (bloc) => bloc.add(LoadHomeDataEvent()),
    expect: () => [
      const HomeState(status: HomeStatus.loading),
      const HomeState(status: HomeStatus.error, errorMessage: 'Lỗi Server Tin Tức'),
    ],
  );
}
