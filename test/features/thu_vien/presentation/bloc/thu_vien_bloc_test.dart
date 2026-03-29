import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dxmd_app/core/error/failures.dart';
import 'package:dxmd_app/features/thu_vien/domain/entities/thu_vien.dart';
import 'package:dxmd_app/features/thu_vien/domain/usecases/get_thu_vien.dart';
import 'package:dxmd_app/features/thu_vien/presentation/bloc/thu_vien_bloc.dart';
import 'package:dxmd_app/features/thu_vien/presentation/bloc/thu_vien_event.dart';
import 'package:dxmd_app/features/thu_vien/presentation/bloc/thu_vien_state.dart';

class MockGetThuVien extends Mock implements GetThuVien {}

void main() {
  late ThuVienBloc thuVienBloc;
  late MockGetThuVien mockGetThuVien;

  setUp(() {
    mockGetThuVien = MockGetThuVien();
    thuVienBloc = ThuVienBloc(getThuVien: mockGetThuVien);
  });

  tearDown(() {
    thuVienBloc.close();
  });

  const tCategoryId = 1;
  final tThuVienList = <ThuVien>[
    const ThuVien(
      id: 1,
      title: 'Gallery 1',
      categoryId: tCategoryId,
    )
  ];

  test('initial state should be initial', () {
    expect(thuVienBloc.state, const ThuVienState(status: ThuVienStatus.initial));
  });

  blocTest<ThuVienBloc, ThuVienState>(
    'emits [loading, success] when FetchThuVienEvent is added and succeeds',
    build: () {
      when(() => mockGetThuVien(any(), any(), categoryId: any(named: 'categoryId')))
          .thenAnswer((_) async => Right(tThuVienList));
      return thuVienBloc;
    },
    act: (bloc) => bloc.add(const FetchThuVienEvent(categoryId: tCategoryId)),
    expect: () => [
      const ThuVienState(status: ThuVienStatus.loading),
      ThuVienState(status: ThuVienStatus.success, thuVienList: tThuVienList, hasReachedMax: true),
    ],
    verify: (_) {
      verify(() => mockGetThuVien(1, 14, categoryId: tCategoryId)).called(1);
    },
  );

  blocTest<ThuVienBloc, ThuVienState>(
    'emits [loading, failure] when FetchThuVienEvent fails',
    build: () {
      when(() => mockGetThuVien(any(), any(), categoryId: any(named: 'categoryId')))
          .thenAnswer((_) async => const Left(ServerFailure('Lỗi truy xuất thư viện')));
      return thuVienBloc;
    },
    act: (bloc) => bloc.add(const FetchThuVienEvent(categoryId: tCategoryId)),
    expect: () => [
      const ThuVienState(status: ThuVienStatus.loading),
      const ThuVienState(status: ThuVienStatus.failure, errorMessage: 'Lỗi truy xuất thư viện'),
    ],
  );
}
