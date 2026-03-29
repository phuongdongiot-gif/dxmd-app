import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_thu_vien.dart';
import 'thu_vien_event.dart';
import 'thu_vien_state.dart';

class ThuVienBloc extends Bloc<ThuVienEvent, ThuVienState> {
  final GetThuVien getThuVien;
  int currentPage = 1;
  static const int perPage = 14;

  ThuVienBloc({required this.getThuVien}) : super(const ThuVienState()) {
    on<FetchThuVienEvent>(_onFetchThuVien);
    on<LoadMoreThuVienEvent>(_onLoadMoreThuVien);
  }

  Future<void> _onFetchThuVien(FetchThuVienEvent event, Emitter<ThuVienState> emit) async {
    emit(state.copyWith(status: ThuVienStatus.loading));
    currentPage = 1;

    final result = await getThuVien(currentPage, perPage, categoryId: event.categoryId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ThuVienStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: ThuVienStatus.success,
        thuVienList: data,
        hasReachedMax: data.length < perPage,
      )),
    );
  }

  Future<void> _onLoadMoreThuVien(LoadMoreThuVienEvent event, Emitter<ThuVienState> emit) async {
    if (state.hasReachedMax || state.status == ThuVienStatus.loading) return;

    currentPage++;
    final result = await getThuVien(currentPage, perPage, categoryId: event.categoryId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ThuVienStatus.failure,
        errorMessage: failure.message,
      )),
      (data) {
        if (data.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(state.copyWith(
            status: ThuVienStatus.success,
            thuVienList: List.of(state.thuVienList)..addAll(data),
            hasReachedMax: data.length < perPage,
          ));
        }
      },
    );
  }
}
