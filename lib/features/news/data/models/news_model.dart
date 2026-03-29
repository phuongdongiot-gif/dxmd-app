import '../../domain/entities/news.dart';

class NewsModel extends News {
  const NewsModel({
    required super.id,
    required super.title,
    required super.content,
    required super.excerpt,
    required super.slug,
    super.featureImageUrl,
    super.date,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    if (json['_embedded'] != null && json['_embedded']['wp:featuredmedia'] != null) {
      final mediaList = json['_embedded']['wp:featuredmedia'] as List;
      if (mediaList.isNotEmpty && mediaList[0]['source_url'] != null) {
        imageUrl = mediaList[0]['source_url'] as String;
      }
    }

    return NewsModel(
      id: json['id'] as int,
      title: json['title']['rendered'] as String,
      content: json['content']['rendered'] as String,
      excerpt: json['excerpt']['rendered'] as String,
      slug: json['slug'] as String,
      featureImageUrl: imageUrl,
      date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
    );
  }
}
