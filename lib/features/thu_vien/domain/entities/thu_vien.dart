import 'package:equatable/equatable.dart';

class ThuVien extends Equatable {
  final int id;
  final String title;
  final String? excerpt;
  final String? featureImageUrl;
  final List<String> listImg;

  const ThuVien({
    required this.id,
    required this.title,
    this.excerpt,
    this.featureImageUrl,
    this.listImg = const [],
  });

  @override
  List<Object?> get props => [id, title, excerpt, featureImageUrl, listImg];
}
