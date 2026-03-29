import '../../domain/entities/thu_vien.dart';

class ThuVienModel extends ThuVien {
  const ThuVienModel({
    required super.id,
    required super.title,
    super.excerpt,
    super.featureImageUrl,
    super.listImg = const [],
    super.categoryId,
    super.videoId,
    super.taiLieuList = const [],
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

    List<String> listImg = [];
    if (json['acf'] != null && json['acf']['list_img'] != null) {
      final imgDynamicList = json['acf']['list_img'];
      if (imgDynamicList is List) {
        listImg = imgDynamicList.whereType<String>().toList();
      }
    }

    int? categoryId;
    if (json['loai-thu-vien'] != null && json['loai-thu-vien'] is List && (json['loai-thu-vien'] as List).isNotEmpty) {
      categoryId = (json['loai-thu-vien'] as List)[0] as int;
    }

    String? videoId;
    if (json['acf'] != null && json['acf']['id_video_youtube'] != null) {
      videoId = json['acf']['id_video_youtube'].toString();
      if (videoId.trim().isEmpty) videoId = null;
    }

    List<Map<String, String>> taiLieuList = [];
    if (json['acf'] != null && json['acf']['tai-lieu'] != null) {
      final tlList = json['acf']['tai-lieu'];
      if (tlList is List) {
        for (var item in tlList) {
          if (item is Map) {
            taiLieuList.add({
              'file_name': item['file_name']?.toString() ?? '',
              'file_url': item['file_url']?.toString() ?? '',
            });
          }
        }
      }
    }

    return ThuVienModel(
      id: json['id'] as int,
      title: title,
      excerpt: excerpt,
      featureImageUrl: imageUrl,
      listImg: listImg,
      categoryId: categoryId,
      videoId: videoId,
      taiLieuList: taiLieuList,
    );
  }
}
