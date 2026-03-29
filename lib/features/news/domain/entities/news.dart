import 'package:equatable/equatable.dart';

class News extends Equatable {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String slug;
  final String? featureImageUrl;
  final DateTime? date;

  const News({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.slug,
    this.featureImageUrl,
    this.date,
  });

  @override
  List<Object?> get props => [id, title, content, excerpt, slug, featureImageUrl, date];
}
