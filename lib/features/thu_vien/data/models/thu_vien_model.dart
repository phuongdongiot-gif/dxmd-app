import '../../domain/entities/thu_vien.dart';

class ThuVienModel extends ThuVien {
  const ThuVienModel({
    required super.id,
    required super.title,
    super.excerpt,
    super.featureImageUrl,
  });

  factory ThuVienModel.fromJson(Map<String, dynamic> json) {
    String title = '';
    if (json['title'] != null && json['title']['rendered'] != null) {
      title = json['title']['rendered'] as String;
    }

    String? excerpt;
    if (json['excerpt'] != null && json['excerpt']['rendered'] != null) {
      excerpt = json['excerpt']['rendered'] as String;
    }

    String? imageUrl;
    if (json['_embedded'] != null && json['_embedded']['wp:featuredmedia'] != null) {
      final mediaList = json['_embedded']['wp:featuredmedia'] as List;
      if (mediaList.isNotEmpty && mediaList[0]['source_url'] != null) {
        imageUrl = mediaList[0]['source_url'] as String;
      }
    }

    return ThuVienModel(
      id: json['id'] as int,
      title: title,
      excerpt: excerpt,
      featureImageUrl: imageUrl,
    );
  }
}
