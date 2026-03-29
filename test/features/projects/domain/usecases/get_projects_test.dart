import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dxmd_app/features/projects/domain/entities/project.dart';
import 'package:dxmd_app/features/projects/domain/repositories/project_repository.dart';
import 'package:dxmd_app/features/projects/domain/usecases/get_projects.dart';
import 'package:dxmd_app/core/error/failures.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late GetProjects usecase;
  late MockProjectRepository mockProjectRepository;

  setUp(() {
    mockProjectRepository = MockProjectRepository();
    usecase = GetProjects(mockProjectRepository);
  });

  const tPage = 1;
  const tPerPage = 10;
  final tProjects = <Project>[
    const Project(
      id: 1,
      title: 'Test Project',
      slug: 'test-project',
      content: 'Test Content',
    )
  ];

  test('should get projects from the repository', () async {
    // arrange
    when(() => mockProjectRepository.getProjects(page: tPage, perPage: tPerPage))
        .thenAnswer((_) async => Right(tProjects));

    // act
    final result = await usecase(const GetProjectsParams(page: tPage, perPage: tPerPage));

    // assert
    expect(result, Right(tProjects));
    verify(() => mockProjectRepository.getProjects(page: tPage, perPage: tPerPage));
    verifyNoMoreInteractions(mockProjectRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(() => mockProjectRepository.getProjects(page: tPage, perPage: tPerPage))
        .thenAnswer((_) async => const Left(ServerFailure('Server Error')));

    // act
    final result = await usecase(const GetProjectsParams(page: tPage, perPage: tPerPage));

    // assert
    expect(result, const Left(ServerFailure('Server Error')));
    verify(() => mockProjectRepository.getProjects(page: tPage, perPage: tPerPage));
    verifyNoMoreInteractions(mockProjectRepository);
  });
}
