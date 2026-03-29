import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_recruitments.dart';
import 'recruitment_event.dart';
import 'recruitment_state.dart';

class RecruitmentBloc extends Bloc<RecruitmentEvent, RecruitmentState> {
  final GetRecruitments getRecruitments;

  RecruitmentBloc({required this.getRecruitments}) : super(const RecruitmentState()) {
    on<FetchRecruitmentsEvent>(_onFetchRecruitments);
  }

  Future<void> _onFetchRecruitments(FetchRecruitmentsEvent event, Emitter<RecruitmentState> emit) async {
    emit(state.copyWith(status: RecruitmentStatus.loading));

    final result = await getRecruitments(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: RecruitmentStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: RecruitmentStatus.success,
        recruitment: data,
      )),
    );
  }
}
