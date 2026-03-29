import 'package:equatable/equatable.dart';
import '../../domain/entities/recruitment.dart';

enum RecruitmentStatus { initial, loading, success, failure }

class RecruitmentState extends Equatable {
  final RecruitmentStatus status;
  final Recruitment? recruitment;
  final String errorMessage;

  const RecruitmentState({
    this.status = RecruitmentStatus.initial,
    this.recruitment,
    this.errorMessage = '',
  });

  RecruitmentState copyWith({
    RecruitmentStatus? status,
    Recruitment? recruitment,
    String? errorMessage,
  }) {
    return RecruitmentState(
      status: status ?? this.status,
      recruitment: recruitment ?? this.recruitment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recruitment, errorMessage];
}
