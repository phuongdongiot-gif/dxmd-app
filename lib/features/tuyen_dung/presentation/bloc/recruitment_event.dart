import 'package:equatable/equatable.dart';

abstract class RecruitmentEvent extends Equatable {
  const RecruitmentEvent();

  @override
  List<Object> get props => [];
}

class FetchRecruitmentsEvent extends RecruitmentEvent {}
