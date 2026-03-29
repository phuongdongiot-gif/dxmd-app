import 'package:equatable/equatable.dart';

class Recruitment extends Equatable {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String slug;
  final String? featureImageUrl;

  const Recruitment({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.slug,
    this.featureImageUrl,
  });

  @override
  List<Object?> get props => [id, title, content, excerpt, slug, featureImageUrl];
}
