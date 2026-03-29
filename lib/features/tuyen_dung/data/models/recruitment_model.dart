import '../../domain/entities/recruitment.dart';

class RecruitmentModel extends Recruitment {
  const RecruitmentModel({
    required super.id,
    required super.title,
    required super.content,
    required super.excerpt,
    required super.slug,
    super.featureImageUrl,
  });

  factory RecruitmentModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    if (json['_embedded'] != null && json['_embedded']['wp:featuredmedia'] != null) {
      final mediaList = json['_embedded']['wp:featuredmedia'] as List;
      if (mediaList.isNotEmpty && mediaList[0]['source_url'] != null) {
        imageUrl = mediaList[0]['source_url'] as String;
      }
    }

    return RecruitmentModel(
      id: json['id'] as int,
      title: json['title']['rendered'] as String,
      content: json['content']['rendered'] as String,
      excerpt: json['excerpt']['rendered'] as String,
      slug: json['slug'] as String,
      featureImageUrl: imageUrl,
    );
  }
}
