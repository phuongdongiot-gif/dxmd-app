import 'package:equatable/equatable.dart';
import '../../domain/entities/recruitment.dart';

enum RecruitmentStatus { initial, loading, success, failure }

class RecruitmentState extends Equatable {
  final RecruitmentStatus status;
  final List<Recruitment> recruitments;
  final String errorMessage;

  const RecruitmentState({
    this.status = RecruitmentStatus.initial,
    this.recruitments = const [],
    this.errorMessage = '',
  });

  RecruitmentState copyWith({
    RecruitmentStatus? status,
    List<Recruitment>? recruitments,
    String? errorMessage,
  }) {
    return RecruitmentState(
      status: status ?? this.status,
      recruitments: recruitments ?? this.recruitments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recruitments, errorMessage];
}
