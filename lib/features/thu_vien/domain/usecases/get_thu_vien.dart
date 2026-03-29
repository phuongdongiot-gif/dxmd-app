import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/thu_vien.dart';
import '../repositories/thu_vien_repository.dart';

class GetThuVien {
  final ThuVienRepository repository;

  GetThuVien(this.repository);

  Future<Either<Failure, List<ThuVien>>> call(int page, int perPage, {int? categoryId}) async {
    return await repository.getThuVien(page, perPage, categoryId: categoryId);
  }
}
