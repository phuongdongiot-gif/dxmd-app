import '../../domain/entities/recruitment.dart';

class RecruitmentModel extends Recruitment {
  const RecruitmentModel({
    required super.id,
    required super.title,
    required super.content,
    required super.excerpt,
    required super.slug,
    super.featureImageUrl,
    super.position,
    super.qty,
    super.address,
    super.dateEnd,
  });

  factory RecruitmentModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    if (json['_embedded'] != null && json['_embedded']['wp:featuredmedia'] != null) {
      final mediaList = json['_embedded']['wp:featuredmedia'] as List;
      if (mediaList.isNotEmpty && mediaList[0]['source_url'] != null) {
        imageUrl = mediaList[0]['source_url'] as String;
      }
    }

    final acf = json['acf'];

    return RecruitmentModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] != null ? json['title']['rendered'] as String : '',
      content: _parseAcfString(acf, 'content') ?? 
               (json['content'] != null ? json['content']['rendered'] as String : ''),
      excerpt: json['excerpt'] != null ? json['excerpt']['rendered'] as String : '',
      slug: json['slug'] as String? ?? '',
      featureImageUrl: imageUrl,
      position: _parseAcfString(acf, 'position'),
      qty: _parseAcfString(acf, 'qty'),
      address: _parseAcfString(acf, 'address'),
      dateEnd: _parseAcfString(acf, 'date_end'),
    );
  }

  static String? _parseAcfString(dynamic acf, String key) {
    if (acf == null) return null;
    final value = acf[key];
    if (value == null || value is bool) return null;
    final str = value.toString().trim();
    if (str.isEmpty) return null;
    return str;
  }
}
