import 'package:equatable/equatable.dart';

class Recruitment extends Equatable {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String slug;
  final String? featureImageUrl;
  final String? position;
  final String? qty;
  final String? address;
  final String? dateEnd;

  const Recruitment({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.slug,
    this.featureImageUrl,
    this.position,
    this.qty,
    this.address,
    this.dateEnd,
  });

  @override
  List<Object?> get props => [id, title, content, excerpt, slug, featureImageUrl, position, qty, address, dateEnd];
}
