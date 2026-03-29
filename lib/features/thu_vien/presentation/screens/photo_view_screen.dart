import 'package:flutter/material.dart';
import '../../domain/entities/thu_vien.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoViewScreen extends StatefulWidget {
  final ThuVien thuVien;

  const PhotoViewScreen({super.key, required this.thuVien});

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late final PageController _pageController;
  late final List<String> _images;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _images = [];
    if (widget.thuVien.featureImageUrl != null) {
      _images.add(widget.thuVien.featureImageUrl!);
    }
    for (var img in widget.thuVien.listImg) {
      if (!_images.contains(img)) {
        _images.add(img);
      }
    }
    
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _images.isEmpty ? 1 : _images.length,
            itemBuilder: (context, index) {
              final imageUrl = _images.isEmpty ? widget.thuVien.featureImageUrl : _images[index];
              if (imageUrl == null) {
                return const Center(child: Text('Không có hình ảnh', style: TextStyle(color: Colors.white)));
              }

              return InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 1.0,
                maxScale: 4.0,
                child: Hero(
                  tag: index == 0 ? 'gallery_image_${widget.thuVien.id}' : 'gallery_image_${widget.thuVien.id}_$index',
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                    errorWidget: (context, url, err) => const Icon(Icons.error, color: Colors.white, size: 50),
                  ),
                ),
              );
            },
          ),
          
          if (_images.length > 1)
            Positioned(
              top: 100,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                  ],
                ),
                child: Text(
                  '${_currentIndex + 1} / ${_images.length}',
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Text(
          widget.thuVien.title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
