import 'package:equatable/equatable.dart';

abstract class ThuVienEvent extends Equatable {
  const ThuVienEvent();

  @override
  List<Object> get props => [];
}

class FetchThuVienEvent extends ThuVienEvent {
  final int? categoryId;

  const FetchThuVienEvent({this.categoryId});

  @override
  List<Object> get props => [if (categoryId != null) categoryId!];
}

class LoadMoreThuVienEvent extends ThuVienEvent {
  final int? categoryId;

  const LoadMoreThuVienEvent({this.categoryId});

  @override
  List<Object> get props => [if (categoryId != null) categoryId!];
}
