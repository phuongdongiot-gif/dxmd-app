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
          // Background
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Toggle UI visibility if needed (Optional)
              },
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
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

                  // Use InteractiveViewer but restrict horizontal panning when scale is 1.0
                  return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    // If the user wants to swipe, they should be able to.
                    // Flutter handles the conflict relatively well if panAxis is constrained
                    // but on older flutters it doesn't. We'll leave it default for now.
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
            ),
          ),
          
          // Image Counter Indicator
          if (_images.length > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${_images.length}',
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

          // Bottom Content (Title + Carousel)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, top: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.thuVien.title,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Thumbnail Carousel
                  if (_images.length > 1)
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          final isSelected = _currentIndex == index;
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index, 
                                duration: const Duration(milliseconds: 300), 
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 12),
                              width: isSelected ? 80 : 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF0D47A1) : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: isSelected ? [
                                  BoxShadow(color: const Color(0xFF0D47A1).withOpacity(0.5), blurRadius: 8)
                                ] : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: CachedNetworkImage(
                                        imageUrl: _images[index],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(color: Colors.grey[800]),
                                        errorWidget: (context, url, err) => const Icon(Icons.error, color: Colors.white),
                                      ),
                                    ),
                                    if (!isSelected)
                                      Positioned.fill(
                                        child: Container(color: Colors.black.withOpacity(0.4)),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
