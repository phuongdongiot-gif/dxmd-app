import 'package:equatable/equatable.dart';

abstract class ThuVienEvent extends Equatable {
  const ThuVienEvent();

  @override
  List<Object> get props => [];
}

class FetchThuVienEvent extends ThuVienEvent {}

class LoadMoreThuVienEvent extends ThuVienEvent {}
