import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final int id;
  final String title;
  final String content;
  final String slug;
  final String? featureImageUrl;
  final Map<String, dynamic>? acf;

  const Project({
    required this.id,
    required this.title,
    required this.content,
    required this.slug,
    this.featureImageUrl,
    this.acf,
  });

  @override
  List<Object?> get props => [id, title, content, slug, featureImageUrl, acf];
}
