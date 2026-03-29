import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/news.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức nội bộ'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (news.featureImageUrl != null)
              AppNetworkImage(
                imageUrl: news.featureImageUrl!,
                height: 250,
                width: double.infinity,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (news.date != null)
                    Text(
                      'Đăng ngày: ${news.date!.day}/${news.date!.month}/${news.date!.year}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  const SizedBox(height: 16),
                  Html(
                    data: news.content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(16.0),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "img": Style(
                        width: Width(MediaQuery.of(context).size.width - 32),
                      ),
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
