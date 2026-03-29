import 'package:equatable/equatable.dart';

class ThuVien extends Equatable {
  final int id;
  final String title;
  final String? excerpt;
  final String? featureImageUrl;
  final List<String> listImg;
  final int? categoryId; // 7: image, 8: video, 9: document
  final String? videoId; // from acf.id_video_youtube
  final List<Map<String, String>> taiLieuList; // from acf.tai-lieu

  const ThuVien({
    required this.id,
    required this.title,
    this.excerpt,
    this.featureImageUrl,
    this.listImg = const [],
    this.categoryId,
    this.videoId,
    this.taiLieuList = const [],
  });

  @override
  List<Object?> get props => [id, title, excerpt, featureImageUrl, listImg, categoryId, videoId, taiLieuList];
}
