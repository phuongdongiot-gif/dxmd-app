import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/thu_vien.dart';

abstract class ThuVienRepository {
  Future<Either<Failure, List<ThuVien>>> getThuVien(int page, int perPage);
}
