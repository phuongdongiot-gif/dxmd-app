import 'package:flutter/material.dart';
import '../../domain/entities/thu_vien.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoViewScreen extends StatelessWidget {
  final ThuVien thuVien;

  const PhotoViewScreen({super.key, required this.thuVien});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 1.0,
          maxScale: 4.0,
          child: Hero(
            tag: 'gallery_image_${thuVien.id}',
            child: CachedNetworkImage(
              imageUrl: thuVien.featureImageUrl!,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
              errorWidget: (context, url, err) => const Icon(Icons.error, color: Colors.white, size: 50),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black.withOpacity(0.5),
        child: Text(
          thuVien.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
