import 'package:equatable/equatable.dart';
import '../../domain/entities/thu_vien.dart';

enum ThuVienStatus { initial, loading, success, failure }

class ThuVienState extends Equatable {
  final ThuVienStatus status;
  final List<ThuVien> thuVienList;
  final bool hasReachedMax;
  final String errorMessage;

  const ThuVienState({
    this.status = ThuVienStatus.initial,
    this.thuVienList = const <ThuVien>[],
    this.hasReachedMax = false,
    this.errorMessage = '',
  });

  ThuVienState copyWith({
    ThuVienStatus? status,
    List<ThuVien>? thuVienList,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return ThuVienState(
      status: status ?? this.status,
      thuVienList: thuVienList ?? this.thuVienList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, thuVienList, hasReachedMax, errorMessage];
}
