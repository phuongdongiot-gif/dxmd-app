import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.content,
    required super.slug,
    super.featureImageUrl,
    super.acf,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Extract feature image from _embedded if available, or yoast_head_json
    String? imageUrl;
    if (json['_embedded'] != null && json['_embedded']['wp:featuredmedia'] != null) {
      final mediaList = json['_embedded']['wp:featuredmedia'] as List;
      if (mediaList.isNotEmpty && mediaList[0]['source_url'] != null) {
        imageUrl = mediaList[0]['source_url'] as String;
      }
    }

    return ProjectModel(
      id: json['id'] as int,
      title: json['title']['rendered'] as String,
      content: json['content']['rendered'] as String,
      slug: json['slug'] as String,
      featureImageUrl: imageUrl,
      acf: json['acf'] != null && json['acf'] is Map ? json['acf'] as Map<String, dynamic> : null,
    );
  }
}
