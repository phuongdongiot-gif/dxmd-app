import 'package:equatable/equatable.dart';

class ThuVien extends Equatable {
  final int id;
  final String title;
  final String? excerpt;
  final String? featureImageUrl;

  const ThuVien({
    required this.id,
    required this.title,
    this.excerpt,
    this.featureImageUrl,
  });

  @override
  List<Object?> get props => [id, title, excerpt, featureImageUrl];
}
