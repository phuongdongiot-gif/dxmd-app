import 'package:get_it/get_it.dart';
import '../network/api_client.dart';

// Home
import '../../features/home/presentation/bloc/home_bloc.dart';

// Projects
import '../../features/projects/data/datasources/project_remote_data_source.dart';
import '../../features/projects/data/repositories/project_repository_impl.dart';
import '../../features/projects/domain/repositories/project_repository.dart';
import '../../features/projects/domain/usecases/get_projects.dart';
import '../../features/projects/presentation/bloc/projects_bloc.dart';
import '../../features/projects/presentation/bloc/project_detail_bloc.dart';

// News
import '../../features/news/data/datasources/news_remote_data_source.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/get_news.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';

// Recruitment
import '../../features/tuyen_dung/data/datasources/recruitment_remote_data_source.dart';
import '../../features/tuyen_dung/data/repositories/recruitment_repository_impl.dart';
import '../../features/tuyen_dung/domain/repositories/recruitment_repository.dart';
import '../../features/tuyen_dung/domain/usecases/get_recruitments.dart';
import '../../features/tuyen_dung/presentation/bloc/recruitment_bloc.dart';

// Thu Vien
import '../../features/thu_vien/data/datasources/thu_vien_remote_data_source.dart';
import '../../features/thu_vien/data/repositories/thu_vien_repository_impl.dart';
import '../../features/thu_vien/domain/repositories/thu_vien_repository.dart';
import '../../features/thu_vien/domain/usecases/get_thu_vien.dart';
import '../../features/thu_vien/presentation/bloc/thu_vien_bloc.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // ! Features - Home, Projects, News, Recruitment
  // BLoCs
  sl.registerFactory(() => HomeBloc(getProjects: sl(), getNews: sl()));
  sl.registerFactory(() => ProjectsBloc(getProjects: sl()));
  sl.registerFactory(() => ProjectDetailBloc(repository: sl()));
  sl.registerFactoryParam<NewsBloc, int?, void>(
    (categoryId, _) => NewsBloc(getNews: sl(), categoryId: categoryId),
  );
  sl.registerFactory(() => RecruitmentBloc(getRecruitments: sl()));
  sl.registerFactory(() => ThuVienBloc(getThuVien: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetProjects(sl()));
  sl.registerLazySingleton(() => GetNews(sl()));
  sl.registerLazySingleton(() => GetRecruitments(sl()));
  sl.registerLazySingleton(() => GetThuVien(sl()));

  // Repositories
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RecruitmentRepository>(
    () => RecruitmentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ThuVienRepository>(
    () => ThuVienRepositoryImpl(remoteDataSource: sl()),
  );

  // DataSources
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<RecruitmentRemoteDataSource>(
    () => RecruitmentRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<ThuVienRemoteDataSource>(
    () => ThuVienRemoteDataSourceImpl(apiClient: sl()),
  );

  // ! Core
  sl.registerLazySingleton(() => ApiClient());

  // ! External
  // If we needed SharedPreferences, internal DBs, etc.
}
